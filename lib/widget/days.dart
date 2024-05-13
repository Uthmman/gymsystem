import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/password_page.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:intl/intl.dart';

class Days extends StatefulWidget {
  final bool isStaff;
  const Days({super.key, this.isStaff = true});

  @override
  State<Days> createState() => _DaysState();
}

class _DaysState extends State<Days> {
  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);

  MainController mainController = Get.find<MainController>();

  StreamSubscription? mainSub;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   mainController.daysScroll.removeListener(mainController.daysScrollListener);
  //   mainController.daysScroll = ScrollController();
  //   super.dispose();
  // }

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

        await mainController.getStaffAttendanceOfMonth(
            mainController.selectedMonth.value,
            mainController.selectedYear.value);
      } else {
        if (mounted) {
          showToast("Permission Denied.", redColor);
        }
        return;
      }
    }, details);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 11,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 40 / 53,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                const Positioned(
                  top: 10,
                  child: Text(
                    "Attendance Records",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (mainController.selectedMonth.value > 1) {
                          setState(() {
                            mainController.selectedMonth.value--;
                          });
                          mainController.getStaffAttendanceOfMonth(
                              mainController.selectedMonth.value,
                              mainController.selectedYear.value);
                        } else if (mainController.selectedYear.value > 2000) {
                          setState(() {
                            mainController.selectedMonth.value = 12;
                            mainController.selectedYear.value--;
                          });
                          mainController.getStaffAttendanceOfMonth(
                              mainController.selectedMonth.value,
                              mainController.selectedYear.value);
                        }
                      },
                      icon: const Icon(Icons.chevron_left_outlined),
                    ),
                    Text(getMonthName(mainController.selectedMonth.value)),
                    IconButton(
                      onPressed: () {
                        if (mainController.selectedMonth.value < 12) {
                          setState(() {
                            mainController.selectedMonth.value++;
                          });
                          mainController.getStaffAttendanceOfMonth(
                              mainController.selectedMonth.value,
                              mainController.selectedYear.value);
                        } else if (mainController.selectedYear.value < 2049) {
                          setState(() {
                            mainController.selectedMonth.value = 1;
                            mainController.selectedYear.value++;
                          });
                          mainController.getStaffAttendanceOfMonth(
                              mainController.selectedMonth.value,
                              mainController.selectedYear.value);
                        }
                      },
                      icon: const Icon(Icons.chevron_right_outlined),
                    ),
                    DropdownButton(
                      value: mainController.selectedYear.value,
                      items: years
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text("$e"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          mainController.selectedYear.value = value!;
                        });
                        mainController.getStaffAttendanceOfMonth(
                            mainController.selectedMonth.value,
                            mainController.selectedYear.value);
                      },
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 40 / 53,
                child: SingleChildScrollView(
                  controller: mainController.daysScroll,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          getDaysInMonth(mainController.selectedYear.value,
                              mainController.selectedMonth.value),
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                              horizontal: 36,
                            ),
                            child: GestureDetector(
                              onTapDown: (details) {
                                if (widget.isStaff) {
                                  onDatePressed(
                                    DateTime(
                                      mainController.selectedYear.value,
                                      mainController.selectedMonth.value,
                                      index + 1,
                                    ),
                                    context,
                                    details,
                                  );
                                }
                              },
                              child: SizedBox(
                                width: 55,
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat("E").format(
                                        DateTime(
                                          mainController.selectedYear.value,
                                          mainController.selectedMonth.value,
                                          index + 1,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${index + 1} ${DateFormat("MMM").format(DateTime(mainController.selectedYear.value, mainController.selectedMonth.value))}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w100,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
