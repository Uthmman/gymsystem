import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/password_page.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:intl/intl.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({super.key});

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);

  MainController mainController = Get.find<MainController>();

  StreamSubscription? mainSub;

  @override
  void dispose() {
    super.dispose();
    mainSub?.cancel();
  }

  @override
  void initState() {
    super.initState();
   
    mainSub = mainController.staffs.listen((v) {
      print("staffs updated");
      addAttendancesUntilToday().then((value) {
        getAttendanceOfTheMonth(today.month, today.year);
      });
    });
  }

  getAttendanceOfTheMonth(int month, int year) async {
    await mainController.getStaffAttendanceOfMonth(month, year);
    print("staffAttendance: ${mainController.staffAttendance.length}");

    setState(() {});
  }

  Future<void> addAttendancesUntilToday() async {
    for (Staff staff in mainController.staffs) {
      final lastAttendance = DateTime.parse(staff.lastAttendance);
      if (staff.isActive == 1) {
        bool attendanceAdded = false;
        for (var i = 1; i <= today.difference(lastAttendance).inDays; i++) {
          print("itemration: $i");

          if (lastAttendance.compareTo(today) != 0) {
            print("day: $i, rfid: ${staff.rfId}");
            final savedDate = lastAttendance.add(Duration(days: i));
            attendanceAdded = true;
            await DatabaseHelper().insertStaffAttendance(
              Attendance(
                id: null,
                date: savedDate.toString(),
                ownerId: staff.rfId,
                type: AttendanceType.absent,
              ),
            );
          }
        }
        if (attendanceAdded) {}
      }
      await DatabaseHelper().updateStaff(
        staff.copyWith(
          lastAttendance: today.toString(),
        ),
        null,
      );
    }
  }

  onDayPressed(
      Attendance attendance, BuildContext context, TapDownDetails details) {
    myMenu(
        context,
        AttendanceType.values
            .map((e) => e.toString().replaceAll("AttendanceType.", ""))
            .toList(), (attendanceType) async {
      AttendanceType type = AttendanceType.absent;
      for (var att in AttendanceType.values) {
        if (att.toString().contains(attendanceType)) {
          type = att;
        }
      }
      print(attendance.toString());
      final permission = await showDialog(
        context: context,
        builder: (context) => const PasswordPage(),
      );
      if (permission) {
        DatabaseHelper().updateStaffAttendance(attendance.copyWith(
          type: type,
        ));

        getAttendanceOfTheMonth(mainController.selectedMonth.value,
            mainController.selectedYear.value);
      } else {
        if (mounted) {
          showToast("Permission Denied.", redColor);
        }
        return;
      }
    }, details);
  }

  onDatePressed(
      DateTime dateTime, BuildContext context, TapDownDetails details) {
    myMenu(
        context,
        AttendanceType.values
            .map((e) => e.toString().replaceAll("AttendanceType.", ""))
            .toList(), (attendanceType) async {
      AttendanceType type = AttendanceType.absent;
      for (var att in AttendanceType.values) {
        if (att.toString().contains(attendanceType)) {
          type = att;
        }
      }
      print(dateTime.toString());
      final permission = await showDialog(
        context: context,
        builder: (context) => const PasswordPage(),
      );
      if (permission) {
        await DatabaseHelper().updateStaffAttendancesOnADay(dateTime, type);

        getAttendanceOfTheMonth(mainController.selectedMonth.value,
            mainController.selectedYear.value);
      } else {
        if (mounted) {
          showToast("Permission Denied.", redColor);
        }
        return;
      }
    }, details);
  }

  List<Widget> hyphens(int len, {bool isColored = false}) {
    return List.generate(
      len,
      (index) => Container(
        width: 8,
        height: 2,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isColored ? greenColor : Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget getAttendance(List<Attendance> attendances, BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 10);

    if (attendances.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: SizedBox(
          width: 10,
          child: Text(
            " ",
            textAlign: TextAlign.center,
            style: style.copyWith(
              color: Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      );
    }
    Attendance attendance = attendances[0];

    if (attendance.type == AttendanceType.absent) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: redColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: SizedBox(
            width: 10,
            child: Text(
              "A",
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: redColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      );
    } else if (attendance.type == AttendanceType.present) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Tooltip(
          message: DateFormat("h:mm a").format(DateTime.parse(attendance.date)),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: greenColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: SizedBox(
              width: 10,
              child: Text(
                "P",
                textAlign: TextAlign.center,
                style: style.copyWith(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (attendance.type == AttendanceType.holyday) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: yelloColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: SizedBox(
            width: 10,
            child: Text(
              "H",
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: yelloColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      );
    } else if (attendance.type == AttendanceType.late) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Tooltip(
          message: DateFormat("h:mm a").format(DateTime.parse(attendance.date)),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: greenColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: SizedBox(
                  width: 10,
                  child: Text(
                    "P",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                      color: greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 1,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: redColor,
                  border: Border.all(
                    color: redColor,
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(7),
                  ),
                ),
                child: SizedBox(
                  width: 10,
                  child: Text(
                    "L",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                      color: whiteColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (attendance.type == AttendanceType.permission) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: redColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: SizedBox(
                width: 10,
                child: Text(
                  "A",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: greenColor,
                border: Border.all(
                  color: greenColor,
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(7),
                ),
              ),
              child: SizedBox(
                width: 10,
                child: Text(
                  "P",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                    color: whiteColor,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (attendance.type == AttendanceType.weekend) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 10,
            child: Text(
              "W",
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ),
      );
    } else {
      return Text(
        "",
        style: style,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 40 / 53,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 40 / 53,
                child: SingleChildScrollView(
                  controller: mainController.mainScroll,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...mainController.staffs.map((e) {
                        List<Attendance> myAttendance = mainController
                            .staffAttendance
                            .where((a) => a.ownerId == e.rfId)
                            .toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            getDaysInMonth(mainController.selectedYear.value,
                                mainController.selectedMonth.value),
                            (index) => Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.8,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black26,
                                    width: .4,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ...hyphens(2),
                                  getAttendance(
                                    myAttendance
                                        .where((element) =>
                                            DateTime.parse(element.date).day ==
                                            index + 1)
                                        .toList(),
                                    context,
                                  ),
                                  ...hyphens(2),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
