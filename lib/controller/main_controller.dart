import 'dart:async';

import 'package:get/get.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/staff.dart';

import '../model/attendance.dart';
import '../model/member.dart';
import '../model/payment.dart';

class MainController extends GetxController {
  RxList<Member> members = <Member>[].obs;
  RxList<Staff> staffs = <Staff>[].obs;
  RxList<Attendance> memberAttendance = <Attendance>[].obs;
  RxList<Attendance> staffAttendance = <Attendance>[].obs;
  RxList<Payment> payments = <Payment>[].obs;
  Timer? timmer;
  StreamSubscription? mainStream;

  // staff

  getStaff() async {
    staffs.value = await DatabaseHelper().getStaffs();
  }

  getStaffAttendanceOfMonth(int month, int year) async {
    staffAttendance.value =
        await DatabaseHelper().getStaffAttendanceOfMonth(month, year);
  }

  searchStaff(String query) {
    if (timmer != null) {
      timmer!.cancel();
    }
    timmer = Timer(const Duration(seconds: 3), () {
      DatabaseHelper().searchStaffs(query).then((value) {
        staffs.value = value;
      });
    });
  }

  deleteStaff(rfid) async {
    await DatabaseHelper().deleteStaff(rfid);
    await getStaff();
  }

  // Members

  getMembers() async {
    members.value = await DatabaseHelper().getMembers();
  }

  getMembersAttendanceOfMonth(int month, int year) async {
    memberAttendance.value =
        await DatabaseHelper().getMembersAttendanceOfMonth(month, year);
  }

  searchMembers(String query) {
    if (timmer != null) {
      timmer!.cancel();
    }
    timmer = Timer(const Duration(seconds: 3), () {
      DatabaseHelper().searchMembers(query).then((value) {
        members.value = value;
      });
    });
  }

  deleteMember(String rfid) async {
    await DatabaseHelper().deleteMember(rfid);
    await getMembers();
  }

  //Payment
  getPayments() async {
    payments.value = await DatabaseHelper().getPayments();
  }
}
