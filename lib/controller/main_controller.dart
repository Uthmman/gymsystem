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

  // staff

  getStaff() async {
    staffs.value = await DatabaseHelper().getStaffs();
  }

  getStaffAttendanceOfMonth(int month, int year) async {
    staffAttendance.value =
        await DatabaseHelper().getStaffAttendanceOfMonth(month, year);
  }

  deleteStaff(rfid) async {
    await DatabaseHelper().deleteStaff(rfid);
    await getStaff();
  }

  // Members

  getMembers() async {
    members.value = await DatabaseHelper().getMembers();
  }
}
