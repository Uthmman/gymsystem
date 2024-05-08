import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';

class DatabaseConst {
  static const String staff = "Staff";
  static const String member = "Member";
  static const String staffAttendance = "StaffAttendance";
  static const String membersAttendance = "MembersAttendance";
  static const String payments = "Payments";
}

const String dbPath = "/Database/Gym.Database.db";
const Color mainBgColor = Colors.white;
const Color whiteColor = Colors.white70;
const Color mainColor = Color(0xffeab897);
const Color mainBoldColor = Color.fromARGB(255, 224, 166, 128);
const Color redColor = Color(0xffcb0502);
const Color yelloColor = Color(0xfff4ac02);
const Color greenColor = Color(0xff57a38c);
const Color textColor = Colors.black54;

final List<int> years = List.generate(50, (index) => 2000 + index).toList();

int generateRandomInt() {
  final random = Random();
  final number = random.nextInt(90000000) + 10000000; // 10000000 - 99999999
  return number;
}

DateTime parseTimeString(String timeString) {
  final hour = int.parse(timeString.split(":")[0]);
  final minute = int.parse(timeString
      .split(":")[1]
      .replaceAll("AM", '')
      .replaceAll("PM", '')
      .trim());
  final meridian = timeString.split(":")[1].contains("AM") ? "AM" : "PM";

  // Handle AM/PM and 12-hour clock (similar logic as previous example)
  int adjustedHour = hour;
  if (meridian == 'PM' && hour != 12) {
    adjustedHour += 12;
  } else if (meridian == 'AM' && hour == 12) {
    adjustedHour = 0;
  }

  final dateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, adjustedHour, minute);
  return dateTime; // Output: 2024-05-06 08:21:00.000000000Z
}

String generateRandomString() {
  Random random = Random();
  String characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String randomString = '';

  for (int i = 0; i < 10; i++) {
    int randomIndex = random.nextInt(characters.length);
    randomString += characters[randomIndex];
  }

  return randomString;
}

int getDaysInMonth(int year, int month) {
  int daysInMonth = DateTime(year, month + 1, 0).day;
  return daysInMonth;
}

void showToast(BuildContext context, String message, Color bgcolor) {
  // Check if the context is null or if it's not ready yet
  if (ModalRoute.of(context) == null || !ModalRoute.of(context)!.isCurrent) {
    // Context is not ready yet, showToast cannot be performed
    return;
  }
  Get.showSnackbar(GetSnackBar(
    backgroundColor: bgcolor,
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: bgcolor,
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

Future<String?> timePicker(String initialTime, BuildContext context) async {
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: initialTime.isEmpty
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(parseTimeString(initialTime)),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: false,
        ),
        child: child!,
      );
    },
  );

  if (selectedTime != null) {
    final DateTime currentTime = DateTime.now();
    DateTime selectedSheduleDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return DateFormat.jm().format(selectedSheduleDateTime);
  } else {
    return null;
  }
}

Future<DateTime?> datePicker(String initialDate, BuildContext context,
    {int startYear = 1950,
    int endYear = 2020,
    int defaultInitial = 2000}) async {
  print('initialDate:$initialDate');
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate.isEmpty
        ? DateTime(defaultInitial)
        : DateTime.parse(initialDate),
    // initialTime: initialTime.isEmpty

    // builder: (BuildContext context, Widget? child) {
    //   return MediaQuery(
    //     data: MediaQuery.of(context).copyWith(
    //       alwaysUse24HourFormat: false,
    //     ),
    //     child: child!,
    //   );
    // },
    firstDate: DateTime(startYear),
    lastDate: DateTime(endYear),
  );

  return selectedDate;
}

startListeningCard(MainController mainController) {
  try {
    final channel = IOWebSocketChannel.connect('ws://192.168.137.41:8080/');

    mainController.mainStream = channel.stream.listen(
      (data) {
        // Process the RFID data received from the ESP8266
        print('RFID from main: $data');
        // TODO: search and fill the attendance
      },
      onError: (error) {
        showToast(context, 'Error: $error', redColor);
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack Trace: $stackTrace');
  }
}
