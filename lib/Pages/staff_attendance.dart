import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({super.key});

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    // DatabaseHelper.staffs
    addAttendancesUntilToday().then((value) {
      getAttendanceOfTheMonth(today.month, today.year);
    });
  }

  getAttendanceOfTheMonth(int month, int year) async {
    // TODO: Temporary
    List<Attendance> attendances = [];
    for (int i = 0; i < 30; i++) {
      for (Staff staff in DatabaseHelper.staffs) {
        int ran = i % 10;
        attendances.add(
          Attendance(
            id: i,
            date: DateTime.now().subtract(Duration(days: i)).toString(),
            ownerId: staff.rfId,
            type: ran < 2
                ? AttendanceType.present
                : ran < 4
                    ? AttendanceType.absent
                    : ran < 6
                        ? AttendanceType.late
                        : ran < 8
                            ? AttendanceType.permission
                            : AttendanceType.holyday,
          ),
        );
      }
    }
    // await DatabaseHelper().getStaffAttendanceOfMonth(month, year);
    DatabaseHelper.staffAttendance = attendances;
    print("len: ${DatabaseHelper.staffAttendance.length}");
    print(DatabaseHelper.staffAttendance);

    setState(() {});
  }

  Future<void> addAttendancesUntilToday() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();

    // final DateTime lastAttendance = DateTime.parse(
    //     pref.getString('lastStaffAttendance') ??
    //         today.subtract(const Duration(days: 1)).toString());

    // print(lastAttendance.toString());
    // print("dnce: ${today.difference(lastAttendance).inDays}");
    // print("compare: ${lastAttendance.compareTo(today)}");

    // if (lastAttendance.compareTo(today) != 0) {
    //   for (var i = 1; i <= today.difference(lastAttendance).inDays; i++) {
    //     for (Staff staff in DatabaseHelper.staffs) {
    //       print("day: $i, rfid: ${staff.rfId}");
    //       final savedDate = lastAttendance.add(Duration(days: i));
    //       DatabaseHelper().insertStaffAttendance(
    //         Attendance(
    //           id: null,
    //           date: savedDate.toString(),
    //           ownerId: staff.rfId,
    //           type: savedDate.weekday == 6 || savedDate.weekday == 7
    //               ? AttendanceType.weekend
    //               : AttendanceType.absent,
    //         ),
    //       );
    //     }
    // }
    // }

    // pref.setString(
    //   "lastStaffAttendance",
    //   today.toString(),
    // );
  }

  onDayPressed(
      Attendance attendance, BuildContext context, TapDownDetails details) {
    // myMenu(
    //     context,
    //     AttendanceType.values
    //         .map((e) => e.toString().replaceAll("AttendanceType.", ""))
    //         .toList(), (attendanceType) {
    //   AttendanceType type = AttendanceType.absent;
    //   for (var att in AttendanceType.values) {
    //     if (att.toString().contains(attendanceType)) {
    //       type = att;
    //     }
    //   }
    //   print(attendance.toString());
    //   DatabaseHelper().updateStaffAttendance(attendance.copyWith(
    //     type: type,
    //   ));

    //   getAttendanceOfTheMonth(selectedMonth, selectedYear);
    // }, details);
  }

  List<Widget> hyphens(int len) {
    return List.generate(
      len,
      (index) => Container(
        width: 6,
        height: 1.2,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget getAttendanceString(
      List<Attendance> attendances, BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 10);
    if (attendances.isEmpty) {
      return Text(
        "",
        style: style,
      );
    }
    Attendance attendance = attendances[0];

    if (attendance.type == AttendanceType.absent) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "❌",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.present) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "✅",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.holyday) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "H",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.late) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "L",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.permission) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "P",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.weekend) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          onDayPressed(attendance, context, details);
        },
        child: Text(
          "W",
          textAlign: TextAlign.center,
          style: style,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
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
                              horizontal: 35,
                            ),
                            child: SizedBox(
                              width: 55,
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat("E").format(DateTime(
                                        selectedYear,
                                        selectedMonth,
                                        index + 1)),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${index + 1} ${DateFormat("MMM").format(DateTime(selectedYear, selectedMonth))}",
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...DatabaseHelper.staffs.map((e) {
                        List<Attendance> myAttendance = DatabaseHelper
                            .staffAttendance
                            .where((a) => a.ownerId == e.rfId)
                            .toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            getDaysInMonth(selectedYear, selectedMonth),
                            (index) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                  Container(
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
                                      child: getAttendanceString(
                                        myAttendance
                                            .where((element) =>
                                                DateTime.parse(element.date)
                                                    .day ==
                                                index + 1)
                                            .toList(),
                                        context,
                                      ),
                                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
