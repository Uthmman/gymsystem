import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_payment.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/model/member.dart';
import 'package:gymsystem/model/payment.dart';
import 'package:gymsystem/widget/payment_item.dart';
import 'package:gymsystem/widget/sl_btn.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../helper/db_helper.dart';
import '../widget/sl_input.dart';
import '../widget/special_dropdown.dart';
import 'password_page.dart';

class AddMember extends StatefulWidget {
  final Member? member;
  const AddMember({super.key, this.member});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  String selectedGender = "Male";
  final _fullNameTc = TextEditingController();
  final _rfidTc = TextEditingController();

  final _addMemberKey = GlobalKey<FormState>();

  final _phoneTc = TextEditingController();

  MainController mainController = Get.find<MainController>();

  Member? member;

  List<Payment> payments = [];

  @override
  void initState() {
    super.initState();

    if (widget.member == null) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        _rfidTc.text = generateRandomInt().toString();
      });
    }

    if (widget.member != null) {
      populateFeilds();
    }
  }

  populateFeilds() async {
    member = (await DatabaseHelper().getMemberByRfid(widget.member!.rfid))[0];
    _fullNameTc.text = widget.member!.fullName;
    _phoneTc.text = widget.member!.phone;
    _rfidTc.text = widget.member!.rfid;
    selectedGender = widget.member!.gender;

    payments = await DatabaseHelper().getPaymentsOfaMember(widget.member!.rfid);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      // symmetric(
      //   horizontal: MediaQuery.of(context).size.width / 3,
      //   vertical: 50,
      // ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Add Member"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            )
          ],
          leading: widget.member != null
              ? IconButton(
                  onPressed: () async {
                    final permission = await showDialog(
                      context: context,
                      builder: (context) => const PasswordPage(),
                    );
                    if (permission) {
                      await mainController.deleteMember(widget.member!.rfid);
                      if (mounted) {
                        showToast(context, "Successfully deleted.", greenColor);
                        Navigator.pop(context);
                      }
                    } else {
                      if (mounted) {
                        showToast(context, "Permission denied.", redColor);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: redColor,
                  ),
                )
              : const SizedBox(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _addMemberKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/card_verify.gif',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Full Name",
                  hint: 'Alemu Taye',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.name,
                  controller: _fullNameTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SpecialDropdown(
                  noTitle: true,
                  isOutLined: true,
                  onChange: (val) {
                    setState(() {
                      selectedGender = val!;
                    });
                  },
                  title: 'Gender',
                  value: selectedGender,
                  width: double.infinity,
                  list: const ["Male", "Female"],
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Phone",
                  hint: '0921345845',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.phone,
                  controller: _phoneTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "RFID",
                  hint: '8972348762',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.phone,
                  controller: _rfidTc,
                  isOutlined: true,
                  readOnly: true,
                  validation: (val) {
                    if (val!.isEmpty) {
                      return "Please scan the card.";
                    }
                    return null;
                  },
                ),
                widget.member != null
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Text("Payment History"),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 23,
                            ),
                            child: SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: payments.length,
                                itemBuilder: (context, index) => PaymentItem(
                                  payment: payments[index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                SLBtn(
                  text: "Save",
                  onTap: () async {
                    DateTime today =
                        DateTime.parse(DateTime.now().toString().split(" ")[0]);
                    if (_addMemberKey.currentState!.validate()) {
                      if (widget.member != null) {
                        // DateTime startDate =
                        //     DateTime.parse(member!.lastPaymentDate);
                        // DateTime endDate = PaymentType().getEndDate(
                        //   member!.lastPaymentType,
                        //   startDate,
                        // );
                        if (!PaymentType.checkPaymentStatus(
                            member!.lastPaymentDate, member!.lastPaymentType)) {
                          final List<String>? datas = await showDialog(
                            context: context,
                            builder: (context) => const AddPayment(),
                          );
                          if (datas == null) {
                            if (mounted) {
                              showToast(
                                context,
                                "Please add payment fot the member.",
                                redColor,
                              );
                            }
                            return;
                          }
                          DateTime startDate =
                              DateFormat("MMM dd/yyyy").parse(datas[0]);
                          DateTime endDate = PaymentType().getEndDate(
                            datas[1],
                            startDate,
                          );

                          await DatabaseHelper().insertPayment(
                            Payment(
                              id: null,
                              ownerId: _rfidTc.text,
                              startingDate: startDate.toString(),
                              endingDate: endDate.toString(),
                            ),
                          );

                          await DatabaseHelper().updateMember(
                            Member(
                              fullName: _fullNameTc.text,
                              gender: selectedGender,
                              phone: _phoneTc.text,
                              rfid: _rfidTc.text,
                              lastPaymentDate: member!.lastPaymentDate,
                              lastPaymentType: member!.lastPaymentType,
                              registryDate: member!.registryDate,
                              lastAttendance: member!.lastAttendance,
                            ),
                          );
                        } else {
                          await DatabaseHelper().updateMember(
                            Member(
                              fullName: _fullNameTc.text,
                              gender: selectedGender,
                              phone: _phoneTc.text,
                              rfid: _rfidTc.text,
                              lastPaymentDate: member!.lastPaymentDate,
                              lastPaymentType: member!.lastPaymentType,
                              registryDate: member!.registryDate,
                              lastAttendance: member!.lastAttendance,
                            ),
                          );
                        }
                      } else {
                        final List<String>? datas = await showDialog(
                          context: context,
                          builder: (context) => const AddPayment(),
                        );
                        if (datas == null) {
                          if (mounted) {
                            showToast(
                              context,
                              "Please add payment fot the member.",
                              redColor,
                            );
                          }
                          return;
                        }
                        DateTime startDate =
                            DateFormat("MMM dd/yyyy").parse(datas[0]);
                        DateTime endDate = PaymentType().getEndDate(
                          datas[1],
                          startDate,
                        );
                        await DatabaseHelper().insertPayment(
                          Payment(
                            id: null,
                            ownerId: _rfidTc.text,
                            startingDate: startDate.toString(),
                            endingDate: endDate.toString(),
                          ),
                        );
                        await DatabaseHelper().insertMember(
                          Member(
                            fullName: _fullNameTc.text,
                            gender: selectedGender,
                            phone: _phoneTc.text,
                            rfid: _rfidTc.text,
                            lastPaymentDate: startDate.toString(),
                            lastPaymentType: datas[1],
                            registryDate: today.toString(),
                            lastAttendance: today
                                .subtract(const Duration(days: 1))
                                .toString(),
                          ),
                        );
                      }
                      await mainController.getMembers();
                      await mainController.getPayments();
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
