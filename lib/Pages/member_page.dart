import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/member_attendance.dart';

import '../constants.dart';
import 'member_list.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Management'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6.5,
              color: mainColor,
              child: const Row(
                children: [],
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 35,
                  child: MemberList(),
                ),
                Flexible(
                  flex: 40,
                  child: MemberAttendance(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
