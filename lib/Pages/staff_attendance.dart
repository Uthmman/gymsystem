import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:gymsystem/model/staff.dart';
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
    final attendances =
        await DatabaseHelper().getStaffAttendanceOfMonth(month, year);
    DatabaseHelper.staffAttendance = attendances;
    print("len: ${DatabaseHelper.staffAttendance.length}");
    print(DatabaseHelper.staffAttendance);

    setState(() {});
  }

  Future<void> addAttendancesUntilToday() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final DateTime lastAttendance = DateTime.parse(
        pref.getString('lastStaffAttendance') ??
            today.subtract(const Duration(days: 500)).toString());

    print(lastAttendance.toString());
    print("dnce: ${today.difference(lastAttendance).inDays}");
    print("compare: ${lastAttendance.compareTo(today)}");

    if (lastAttendance.compareTo(today) != 0) {
      for (var i = 1; i <= today.difference(lastAttendance).inDays; i++) {
        for (Staff staff in DatabaseHelper.staffs) {
          print("day: $i, rfid: ${staff.rfId}");
          final savedDate = lastAttendance.add(Duration(days: i));
          DatabaseHelper().insertStaffAttendance(
            Attendance(
              id: null,
              date: savedDate.toString(),
              ownerId: staff.rfId,
              type: savedDate.weekday == 6 || savedDate.weekday == 7
                  ? AttendanceType.weekend
                  : AttendanceType.absent,
            ),
          );
        }
      }
    }

    pref.setString(
      "lastStaffAttendance",
      today.toString(),
    );
  }

  onDayPressed(Attendance attendance) {
    myMenu(
        context,
        AttendanceType.values
            .map((e) => e.toString().replaceAll("AttendanceType.", ""))
            .toList(), (attendanceType) {
      AttendanceType type = AttendanceType.absent;
      for (var att in AttendanceType.values) {
        if (att.toString().contains(attendanceType)) {
          type = att;
        }
      }
      print(attendance.toString());
      DatabaseHelper().updateStaffAttendance(attendance.copyWith(
        type: type,
      ));

      getAttendanceOfTheMonth(selectedMonth, selectedYear);
    });
  }

  Widget getAttendanceString(List<Attendance> attendances) {
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
      
        onTap: () {
          onDayPressed(attendance);
        },
        child: Text(
          "❌",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.present) {
      return GestureDetector(
        onTap: () {
          onDayPressed(attendance);
        },
        child: Text(
          "✅",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.holyday) {
      return GestureDetector(
        onTap: () {
          onDayPressed(attendance);
        },
        child: Text(
          "H",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.late) {
      return GestureDetector(
        onTap: () {
          onDayPressed(attendance);
        },
        child: Text(
          "L",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.permission) {
      return GestureDetector(
        onTap: () {
          onDayPressed(attendance);
        },
        child: Text(
          "P",
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    } else if (attendance.type == AttendanceType.weekend) {
      return Text(
        "W",
        textAlign: TextAlign.center,
        style: style,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SizedBox(
          width: 600,
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  getDaysInMonth(selectedYear, selectedMonth) + 1,
                  (index) => index == 0
                      ? Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(),
                                bottom: BorderSide(),
                                top: BorderSide(),
                                left: BorderSide(),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                "Staffs",
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(),
                              bottom: BorderSide(),
                              top: BorderSide(),
                            ),
                          ),
                          child: SizedBox(
                            width: 14,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "$index",
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              ...DatabaseHelper.staffs.map((e) {
                List<Attendance> myAttendance = DatabaseHelper.staffAttendance
                    .where((a) => a.ownerId == e.rfId)
                    .toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(
                    getDaysInMonth(selectedYear, selectedMonth) + 1,
                    (index) => index == 0
                        ? Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(),
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  e.fullName,
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(),
                                bottom: BorderSide(),
                              ),
                            ),
                            child: SizedBox(
                              width: 14,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: getAttendanceString(myAttendance
                                      .where((element) =>
                                          DateTime.parse(element.date).day ==
                                          index)
                                      .toList())),
                            ),
                          ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
