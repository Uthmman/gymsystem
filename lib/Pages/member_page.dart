import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/member_attendance.dart';
import 'package:gymsystem/Pages/member_payment.dart';

import 'member_list.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Members Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Attendance'),
              Tab(text: "Payments")
              // Tab(text: 'Tab 3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MemberList(),
            MemberAttendance(),
            MemberPayment(),
          ],
        ),
      ),
    );
  }
}
