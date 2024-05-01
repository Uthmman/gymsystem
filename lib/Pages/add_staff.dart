import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:gymsystem/widget/sl_btn.dart';
import 'package:gymsystem/widget/sl_input.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final _addStaffKey = GlobalKey<FormState>();
  final _phoneTc = TextEditingController();
  final _fullNameTc = TextEditingController();
  final _rfidTc = TextEditingController();
  final _roleTc = TextEditingController();
  final _startWorkingTc = TextEditingController();

  bool loading = false;

  String generateRandom8DigitNumber() {
    final random = Random();
    final number = random.nextInt(90000000) + 10000000; // 10000000 - 99999999
    return number.toString();
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10)).then((value) {
      _rfidTc.text = generateRandom8DigitNumber();
    });
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
          title: const Text("Add Staff"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _addStaffKey,
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
                SLInput(
                  title: "Phone",
                  hint: '0934988272',
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
                  title: "Role",
                  hint: 'Manager',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.text,
                  controller: _roleTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Started Working from",
                  hint: 'Manager',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.text,
                  controller: _startWorkingTc,
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
                ),
                const SizedBox(
                  height: 30,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SLBtn(
                        text: "Save",
                        onTap: () async {
                          if (_addStaffKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await DatabaseHelper().insertStaff(
                              Staff(
                                fullName: _fullNameTc.text,
                                role: _roleTc.text,
                                startedWorkingFrom: _startWorkingTc.text,
                                phone: _phoneTc.text,
                                rfId: int.parse(_rfidTc.text), 
                                isActive: 0, 
                                shiftType: '',
                              ),
                            );
                            final staffs = await DatabaseHelper().getStaffs();
                            DatabaseHelper.staffs = staffs;
                            setState(() {
                              loading = false;
                            });
                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          }
                        },
                      ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
