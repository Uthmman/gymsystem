import 'package:flutter/material.dart';

class MemberAttendance extends StatefulWidget {
  const MemberAttendance({super.key});

  @override
  State<MemberAttendance> createState() => _MemberAttendanceState();
}

class _MemberAttendanceState extends State<MemberAttendance> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Member Attendance"),);
  }
}