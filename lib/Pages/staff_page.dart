import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/staff_attendance.dart';

import 'staff_list.dart';

class StaffsPage extends StatelessWidget {
  const StaffsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staffs Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Staffs'),
              Tab(text: 'Attendance'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StaffList(),
            StaffAttendance(),
          ],
        ),
      ),
    );
  }
}
