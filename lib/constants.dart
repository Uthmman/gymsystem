import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_member.dart';
import 'package:gymsystem/Pages/add_staff.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/member.dart';
import 'package:gymsystem/widget/scanned.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class DatabaseConst {
  static const String staff = "Staff";
  static const String member = "Member";
  static const String staffAttendance = "StaffAttendance";
  static const String membersAttendance = "MembersAttendance";
  static const String payments = "Payments";
}

const String dbPath = "/Database/Gym.Db.db";
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
  print('realtime $timeString');
  int hour = int.parse(timeString.split(":")[0]);
  final minute = int.parse(timeString
      .split(":")[1]
      .replaceAll("AM", '')
      .replaceAll("PM", '')
      .trim());
  final meridian = timeString.split(":")[1].contains("AM") ? "AM" : "PM";

  print('median $meridian');

  if (meridian == 'PM' && hour != 12) {
    hour += 12;
  } else if (meridian == 'AM' && hour == 12) {
    hour = 0;
  }

  // Return a DateTime object representing the time in 24-hour format
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      hour, minute);
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

void showBottomSheet(
  String message,
  Color bgcolor, {
  String? image,
  bool isLong = false,
  VoidCallback? onTap,
  String? gender,
}) {
  Get.bottomSheet(
    Scanned(
      messege: message,
      onTap: onTap!,
      image: image!,
      gender: gender!,
    ),
    // backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    elevation: 0,
  );
}

void showToast(
  String message,
  Color bgcolor, {
  bool isLong = false,
  VoidCallback? onTap,
  String? image,
}) {
  // Check if the context is null or if it's not ready yet
  Future.delayed(const Duration(milliseconds: 500)).then((value) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: bgcolor,
      message: message,
      mainButton: onTap != null
          ? TextButton(onPressed: onTap, child: const Text("Show details"))
          : null,
      titleText: Row(children: [
        image != null
            ? Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(
                      File(image),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
      duration:
          isLong ? const Duration(seconds: 3) : const Duration(seconds: 2),
    ));
  });
  // .snackbar(
  //   "",
  // message,
  // backgroundColor: bgcolor,
  // duration: const Duration(seconds: 2),
  // );
  // final scaffold = ScaffoldMessenger.of(context);

  // scaffold.showSnackBar(
  //   SnackBar(
  //     backgroundColor: bgcolor,
  //     content: Text(message),
  //     duration: const Duration(seconds: 2),
  //   ),
  // );
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
    details.globalPosition & const Size(40, 40),
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
    initialTime: TimeOfDay.now(),
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
    final channel = IOWebSocketChannel.connect('ws://192.168.4.1:8080/');
    channel.ready.then((value) {
      showToast('Connected succuessfully.', greenColor);
    });

    mainController.mainStream = channel.stream.listen(
      (data) async {
        // Process the RFID data received from the ESP8266
        if (mainController.location == Location.add) {
          mainController.rfid.text = data.toString();
          http.get(Uri.parse('http://192.168.4.1/on'));
        } else {
          print('RFID from main: $data');
          final staff = await DatabaseHelper().scanStaffAttendance(data);
          print(mainController.location);

          if (staff != null) {
            showBottomSheet(
              "${staff.fullName}'s card is deteced.",
              greenColor,
              isLong: true,
              image: staff.image,
              gender: staff.gender,
              onTap: () {
                Get.dialog(AddStaff(
                  staff: staff,
                ));
              },
            );
            http.get(Uri.parse('http://192.168.4.1/on'));
            mainController.getStaff();
          } else {
            final member = await DatabaseHelper().scanMembersAttendance(data);
            if (member != null) {
              final hasPayed = PaymentType.checkPaymentStatus(
                  member.lastPaymentDate, member.lastPaymentType);
              if (hasPayed) {
                showBottomSheet(
                  "${member.fullName}'s card is deteced.",
                  greenColor,
                  isLong: true,
                  image: member.image,
                  gender: member.gender,
                  onTap: () {
                    Get.dialog(AddMember(
                      member: member,
                    ));
                  },
                );

                http.get(Uri.parse('http://192.168.4.1/on'));
                mainController.getMembers();
              } else {
                if (DateTime.now()
                        .compareTo(DateTime.parse(member.lastPaymentDate)) <
                    0) {
                  showToast(
                    "${member.fullName}'s membership starts from ${DateFormat("MMM dd/yyyy").format(DateTime.parse(member.lastPaymentDate))}",
                    redColor,
                    onTap: () {
                      Get.dialog(AddMember(
                        member: member,
                      ));
                    },
                  );
                } else {
                  showToast(
                    "${member.fullName}'s payment subscription has ended.",
                    redColor,
                    onTap: () {
                      Get.dialog(AddMember(
                        member: member,
                      ));
                    },
                  );
                }
                http.get(Uri.parse('http://192.168.4.1/off'));
              }
            } else {
              showToast("Unknown Card.", redColor);
              http.get(Uri.parse('http://192.168.4.1/off'));
            }
          }
        }
      },
      onError: (error) {
        print(error);
        if (error.toString().contains("SocketException:")) {
          showToast(
            'Scanner is disconnected. Please connect it and refresh.',
            redColor,
            isLong: true,
          );
        }
      },
      onDone: () {
        showToast('Device is disconnected.', redColor);
        print('WebSocket connection closed');
      },
    );
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack Trace: $stackTrace');
  }
}
