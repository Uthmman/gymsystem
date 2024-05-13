import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/member.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../model/payment.dart';
import '../widget/sl_btn.dart';
import '../widget/sl_input.dart';
import '../widget/special_dropdown.dart';

class AddPayment extends StatefulWidget {
  final Payment? payment;
  final Member? member;
  const AddPayment({
    super.key,
    this.payment,
    this.member,
  });

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final _formKey = GlobalKey<FormState>();

  final _startsFromTc = TextEditingController();

  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);

  String selectedPaymentType = PaymentType.monthly;

  @override
  void initState() {
    super.initState();

    _startsFromTc.text = DateFormat("MMM dd/yyyy").format(today);

    if (widget.payment != null) {
      _startsFromTc.text = DateFormat("MMM dd/yyyy")
          .format(DateTime.parse(widget.payment!.startingDate));

      selectedPaymentType = widget.payment!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 3,
      ),
      child: Dialog(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    const Text(
                      "Add Payment",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Starts from",
                  hint: 'Apr 7/2020',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.text,
                  controller: _startsFromTc,
                  isOutlined: true,
                  readOnly: true,
                  onTap: () async {
                    if (widget.payment != null) {
                      return;
                    }
                    final date = await datePicker(
                      _startsFromTc.text.isEmpty
                          ? ""
                          : DateFormat("MMM dd/yyyy")
                              .parse(_startsFromTc.text)
                              .toString(),
                      context,
                      startYear: 2010,
                      endYear: 2050,
                      defaultInitial: DateTime.now().year,
                    );
                    if (date != null) {
                      _startsFromTc.text =
                          DateFormat("MMM dd/yyyy").format(date);
                    }
                    print(date);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SpecialDropdown(
                  noTitle: true,
                  isOutLined: true,
                  onChange: (val) {
                    setState(() {
                      selectedPaymentType = val!;
                    });
                  },
                  title: 'Payment Type',
                  value: selectedPaymentType,
                  width: double.infinity,
                  list: PaymentType.list,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLBtn(
                  text: "Save",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.payment != null) {
                        await DatabaseHelper().updatePayment(
                          widget.payment!.copyWith(
                            type: selectedPaymentType,
                            endingDate: PaymentType()
                                .getEndDate(
                                  selectedPaymentType,
                                  DateTime.parse(widget.payment!.startingDate),
                                )
                                .toString(),
                          ),
                        );
                        // update member
                        await DatabaseHelper().updateMember(
                            widget.member!.copyWith(
                              lastPaymentType: selectedPaymentType,
                            ),
                            null);

                        Get.back();
                      } else {
                        if (mounted) {
                          Navigator.pop(context,
                              [_startsFromTc.text, selectedPaymentType]);
                        }
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
