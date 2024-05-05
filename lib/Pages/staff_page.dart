import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/staff_attendance.dart';
import 'package:gymsystem/constants.dart';

import 'staff_list.dart';

class StaffsPage extends StatelessWidget {
  const StaffsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Staffs Page'),
      //   // bottom: const TabBar(
      //   //   tabs: [
      //   //     Tab(text: 'Staffs'),
      //   //     Tab(text: 'Attendance'),
      //   //   ],
      //   // ),
      // ),
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
                  flex: 13,
                  child: StaffList(),
                ),
                Flexible(
                  flex: 40,
                  child: StaffAttendance(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
