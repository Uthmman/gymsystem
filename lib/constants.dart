import 'package:flutter/material.dart';

class DatabaseConst {
  static const String staff = "Staff";
  static const String member = "Member";
  static const String staffAttendance = "StaffAttendance";
  static const String membersAttendance = "MembersAttendance";
  static const String payments = "Payments";
}

const String dbPath = "/db/GymDb.db";
const Color mainBgColor = Colors.white;
const Color whiteColor = Colors.white70;

final List<int> years = List.generate(50, (index) => 2000 + index).toList();

int getDaysInMonth(int year, int month) {
  // Get the number of days in the month
  int daysInMonth = DateTime(year, month + 1, 0).day;
  return daysInMonth;
  // // Handle invalid month values (1-12)
  // if (month < 1 || month > 12) {
  //   throw ArgumentError(
  //       'Invalid month value: $month. Month must be between 1 and 12.');
  // }

  // // Create a DateTime object for the first day of the desired month
  // final firstDay = DateTime(year, month, 1);

  // // Use DateTime subtraction to get the next month's first day
  // final nextMonthFirstDay =
  //     firstDay.add(const Duration(days: 31)); // Add 31 days (adjusted later)

  // // Subtract days to get the actual number of days in the current month
  // return nextMonthFirstDay.difference(firstDay).inDays - 1;
}

void showToast(BuildContext context, String message) {
  // Check if the context is null or if it's not ready yet
  if (context == null ||
      ModalRoute.of(context) == null ||
      !ModalRoute.of(context)!.isCurrent) {
    // Context is not ready yet, showToast cannot be performed
    return;
  }

  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

String getMonthName(int month) {
  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

void myMenu(BuildContext context, List<String> items,
    void Function(String selectedVal) onPressed, TapDownDetails details) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromSize(
    details.globalPosition & Size(40, 40),
    overlay.size,
  );

  // Show the menu
  showMenu(
    context: context,
    position: position,
    items: items
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e),
            ))
        .toList(),
    elevation: 8,
  ).then((value) {
    // Handle the selected menu item
    if (value != null) {
      onPressed(value);
    }
  });
}
