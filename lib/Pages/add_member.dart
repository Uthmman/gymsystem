import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_payment.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/model/member.dart';
import 'package:gymsystem/model/payment.dart';
import 'package:gymsystem/widget/payment_item.dart';
import 'package:gymsystem/widget/sl_btn.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController _rfidTc = TextEditingController();

  final _addMemberKey = GlobalKey<FormState>();

  final _phoneTc = TextEditingController();

  MainController mainController = Get.find<MainController>();

  Member? member;

  List<Payment> payments = [];
  StreamSubscription? listener;

  bool isLoading = false;

  var selectedImagePath;

  @override
  void initState() {
    super.initState();
    mainController.location = Location.add;
    _rfidTc = mainController.rfid;
    // if (widget.member == null) {
    //   Future.delayed(const Duration(seconds: 3)).then((value) {
    //     _rfidTc.text = generateRandomInt().toString();
    //   });
    // }

    if (widget.member != null) {
      populateFeilds();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // listener?.cancel();
    // startListeningCard(mainController);
    mainController.location = Location.main;
    mainController.rfid.text = "";
  }

  // testHttp() async {
  //   try {
  //     final channel = IOWebSocketChannel.connect('ws://192.168.4.1:8080/');
  //     mainController.mainStream?.cancel();

  //     listener = channel.stream.listen(
  //       (data) {
  //         // Process the RFID data received from the ESP8266
  //         print('RFID Data: $data');
  //         _rfidTc.text = data.toString().replaceAll(" ", '');
  //         http.get(Uri.parse('http://192.168.4.1/on'));
  //       },
  //       onError: (error) {
  //         print('Error: $error');
  //       },
  //       onDone: () {
  //         print('WebSocket connection closed');
  //       },
  //     );
  //   } catch (e, stackTrace) {
  //     print('Error: $e');
  //     print('Stack Trace: $stackTrace');
  //   }
  // }

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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 3,
        vertical: 50,
      ),
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
                        showToast("Successfully deleted.", greenColor);
                        Navigator.pop(context);
                      }
                    } else {
                      if (mounted) {
                        showToast("Permission denied.", redColor);
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
                GestureDetector(
                  onTap: () async {
                    final xFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (xFile != null) {
                      selectedImagePath = xFile.path;
                      setState(() {});
                    }
                  },
                  child: selectedImagePath != null
                      ? Image.file(
                          File(
                            selectedImagePath!,
                          ),
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        )
                      : widget.member != null && widget.member!.image.isNotEmpty
                          ? Image.file(
                              File(widget.member!.image),
                              height: 150,
                              fit: BoxFit.cover,
                              width: 150,
                              // color: mainBoldColor,
                            )
                          : const Icon(
                              Icons.image,
                              size: 150,
                              color: mainBoldColor,
                            ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 23),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/card_verify.gif',
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: SLInput(
                          title: "RFID",
                          hint: 'Scan the card',
                          width: 100,
                          inputColor: Colors.black,
                          otherColor: Colors.black54,
                          keyboardType: TextInputType.phone,
                          controller: _rfidTc,
                          isOutlined: true,
                          readOnly: true,
                          margin: 0,
                          validation: (val) {
                            if (val!.isEmpty) {
                              return "Please scan the card.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
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
                                  onEdit: index == payments.length - 1
                                      ? () async {
                                          await showDialog(
                                            context: context,
                                            builder: (c) => AddPayment(
                                              payment: payments[index],
                                              member: member,
                                            ),
                                          );

                                          mainController.getMembers();
                                          member = (await DatabaseHelper()
                                              .getMemberByRfid(
                                                  widget.member!.rfid))[0];
                                          payments = await DatabaseHelper()
                                              .getPayments();
                                          setState(() {});
                                        }
                                      : null,
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
                isLoading
                    ? const CircularProgressIndicator()
                    : SLBtn(
                        text: "Save",
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            DateTime today = DateTime.parse(
                                DateTime.now().toString().split(" ")[0]);
                            if (_addMemberKey.currentState!.validate()) {
                              if (widget.member != null) {
                                // DateTime startDate =
                                //     DateTime.parse(member!.lastPaymentDate);
                                // DateTime endDate = PaymentType().getEndDate(
                                //   member!.lastPaymentType,
                                //   startDate,
                                // );
                                if (!PaymentType.checkPaymentStatus(
                                    member!.lastPaymentDate,
                                    member!.lastPaymentType)) {
                                  final List<String>? datas = await showDialog(
                                    context: context,
                                    builder: (context) => const AddPayment(),
                                  );
                                  if (datas == null) {
                                    if (mounted) {
                                      showToast(
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
                                      type: datas[1],
                                    ),
                                  );

                                  await DatabaseHelper().updateMember(
                                    Member(
                                      image: '',
                                      fullName: _fullNameTc.text,
                                      gender: selectedGender,
                                      phone: _phoneTc.text,
                                      rfid: _rfidTc.text,
                                      lastPaymentDate: startDate.toString(),
                                      lastPaymentType: datas[1],
                                      registryDate: member!.registryDate,
                                      lastAttendance: member!.lastAttendance,
                                    ),
                                    member!.rfid,
                                  );
                                } else {
                                  await DatabaseHelper().updateMember(
                                    Member(
                                      image: selectedImagePath ?? member!.image,
                                      fullName: _fullNameTc.text,
                                      gender: selectedGender,
                                      phone: _phoneTc.text,
                                      rfid: _rfidTc.text,
                                      lastPaymentDate: member!.lastPaymentDate,
                                      lastPaymentType: member!.lastPaymentType,
                                      registryDate: member!.registryDate,
                                      lastAttendance: member!.lastAttendance,
                                    ),
                                    member!.rfid,
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
                                    type: datas[1],
                                  ),
                                );
                                await DatabaseHelper().insertMember(
                                  Member(
                                    image: selectedImagePath ?? "",
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
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              await mainController.getPayments();
                              await mainController.getMembers();
                              setState(() {
                                isLoading = true;
                              });
                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            }
                          } catch (e) {
                            if (e
                                .toString()
                                .contains("UNIQUE constraint failed")) {
                              showToast("The card is already used.", redColor);
                            } else {
                              showToast("error: ${e.toString()}", redColor);
                            }
                            print("error: ${e.toString()}");
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
