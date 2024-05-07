import 'package:flutter/material.dart';
import 'package:gymsystem/model/member.dart';

import '../constants.dart';
import '../widget/sl_input.dart';
import '../widget/special_dropdown.dart';

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
          leading: IconButton(
            onPressed: () {
              // TODO: delete funtionality
            },
            icon: const Icon(
              Icons.delete,
              color: redColor,
            ),
          ),
        ),
        body: Column(
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
              keyboardType: TextInputType.name,
              controller: _fullNameTc,
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
          ],
        ),
      ),
    );
  }
}
