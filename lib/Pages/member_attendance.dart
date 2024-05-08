import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controller/main_controller.dart';
import '../helper/db_helper.dart';
import '../model/attendance.dart';
import '../model/member.dart';
import '../model/payment.dart';
import '../model/staff.dart';
import 'password_page.dart';

class MemberAttendance extends StatefulWidget {
  const MemberAttendance({super.key});

  @override
  State<MemberAttendance> createState() => _MemberAttendanceState();
}

class _MemberAttendanceState extends State<MemberAttendance> {
  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

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

    // DatabaseHelper.staffs

    mainSub = mainController.members.listen((v) {
      print("members updated");
      addAttendancesUntilToday().then((value) {
        getAttendanceOfTheMonth(today.month, today.year);
      });
    });
  }

  getAttendanceOfTheMonth(int month, int year) async {
    // for (int i = 0; i < 30; i++) {
    //   for (Staff staff in DatabaseHelper.staffs) {
    //     int ran = i % 10;
    //     attendances.add(
    //       Attendance(
    //         id: i,
    //         date: DateTime.now().subtract(Duration(days: i)).toString(),
    //         ownerId: staff.rfId,
    //         type: ran < 2
    //             ? AttendanceType.present
    //             : ran < 4
    //                 ? AttendanceType.absent
    //                 : ran < 6
    //                     ? AttendanceType.late
    //                     : ran < 8
    //                         ? AttendanceType.permission
    //                         : AttendanceType.holyday,
    //       ),
    //     );
    //   }
    // }
    await mainController.getMembersAttendanceOfMonth(month, year);
    await mainController.getPayments();
    print("payments: ${mainController.payments.length}");
    print("memberAttendance: ${mainController.memberAttendance.length}");
    // print("len: ${DatabaseHelper.staffAttendance.length}");
    // print(DatabaseHelper.staffAttendance);

    setState(() {});
  }

  Future<void> addAttendancesUntilToday() async {
    for (Member member in mainController.members) {
      final lastAttendance = DateTime.parse(member.lastAttendance);
      if (PaymentType.checkPaymentStatus(
          member.lastPaymentDate, member.lastPaymentType)) {
        bool attendanceAdded = false;
        for (var i = 1; i <= today.difference(lastAttendance).inDays; i++) {
          print("itemration: $i");

          if (lastAttendance.compareTo(today) != 0) {
            print("day: $i, rfid: ${member.rfid}");
            final savedDate = lastAttendance.add(Duration(days: i));
            attendanceAdded = true;
            await DatabaseHelper().insertMemberAttendance(
              Attendance(
                id: null,
                date: savedDate.toString(),
                ownerId: member.rfid,
                type: AttendanceType.absent,
              ),
            );
          }
        }
        if (attendanceAdded) {
          await DatabaseHelper().updateMember(
            member.copyWith(
              lastAttendance: today.toString(),
            ),
          );
        }
      }
    }

    // pref.setString(
    //   "lastStaffAttendance",
    //   today.toString(),
    // );
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
        DatabaseHelper().updateMemberAttendance(attendance.copyWith(
          type: type,
        ));

        getAttendanceOfTheMonth(selectedMonth, selectedYear);
      } else {
        if (mounted) {
          showToast(context, "Permission Denied.", redColor);
        }
        return;
      }
    }, details);
  }

  List<Widget> hyphens(int len, List<Payment> payments) {
    if (payments.isEmpty) {
      return List.generate(
        len,
        (index) => Container(
          width: 8,
          height: 2,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      return List.generate(
        len,
        (index) => Container(
          width: 8,
          height: 2,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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
        child: Container(
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
              "-",
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
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
                        if (selectedMonth > 1) {
                          setState(() {
                            selectedMonth--;
                          });
                          getAttendanceOfTheMonth(selectedMonth, selectedYear);
                        } else if (selectedYear > 2000) {
                          setState(() {
                            selectedMonth = 12;
                            selectedYear--;
                          });
                          getAttendanceOfTheMonth(selectedMonth, selectedYear);
                        }
                      },
                      icon: const Icon(Icons.chevron_left_outlined),
                    ),
                    Text(getMonthName(selectedMonth)),
                    IconButton(
                      onPressed: () {
                        if (selectedMonth < 12) {
                          setState(() {
                            selectedMonth++;
                          });
                          getAttendanceOfTheMonth(selectedMonth, selectedYear);
                        } else if (selectedYear < 2049) {
                          setState(() {
                            selectedMonth = 1;
                            selectedYear++;
                          });
                          getAttendanceOfTheMonth(selectedMonth, selectedYear);
                        }
                      },
                      icon: const Icon(Icons.chevron_right_outlined),
                    ),
                    DropdownButton(
                      value: selectedYear,
                      items: years
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text("$e"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                        getAttendanceOfTheMonth(selectedMonth, selectedYear);
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
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          getDaysInMonth(selectedYear, selectedMonth),
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                              horizontal: 36,
                            ),
                            child: SizedBox(
                              width: 55,
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat("E").format(
                                      DateTime(
                                        selectedYear,
                                        selectedMonth,
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
                                    "${index + 1} ${DateFormat("MMM").format(DateTime(selectedYear, selectedMonth))}",
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
                      const SizedBox(
                        height: 8,
                      ),
                      ...mainController.members.map((e) {
                        List<Attendance> myAttendance = mainController
                            .memberAttendance
                            .where((a) => a.ownerId == e.rfid)
                            .toList();
                        List<Payment> myPayment = mainController.payments
                            .where((p) => p.ownerId == e.rfid)
                            .toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            getDaysInMonth(selectedYear, selectedMonth),
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
                                  ...hyphens(
                                    2,
                                    myPayment
                                        .where((element) =>
                                            DateTime(
                                                  selectedYear,
                                                  selectedMonth,
                                                  index + 1,
                                                ).compareTo(
                                                  DateTime.parse(
                                                      element.startingDate),
                                                ) >
                                                0 &&
                                            DateTime(
                                                  selectedYear,
                                                  selectedMonth,
                                                  index,
                                                ).compareTo(
                                                  DateTime.parse(
                                                      element.endingDate),
                                                ) <
                                                0)
                                        .toList(),
                                  ),
                                  getAttendance(
                                    myAttendance
                                        .where((element) =>
                                            DateTime.parse(element.date).day ==
                                            index + 1)
                                        .toList(),
                                    context,
                                  ),
                                  ...hyphens(
                                    2,
                                    myPayment
                                        .where((element) =>
                                            DateTime(
                                                  selectedYear,
                                                  selectedMonth,
                                                  index + 1,
                                                ).compareTo(
                                                  DateTime.parse(
                                                      element.startingDate),
                                                ) >=
                                                0 &&
                                            DateTime(
                                                  selectedYear,
                                                  selectedMonth,
                                                  index + 1,
                                                ).compareTo(
                                                  DateTime.parse(
                                                      element.endingDate),
                                                ) <
                                                0)
                                        .toList(),
                                  ),
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
