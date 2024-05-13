import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/staff_attendance.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/controller/main_controller.dart';

import 'staff_list.dart';

class StaffsPage extends StatefulWidget {
  const StaffsPage({
    super.key,
  });

  @override
  State<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends State<StaffsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Wellness'),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Get.find<MainController>().mainStream?.cancel();
              startListeningCard(
                Get.find<MainController>(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 11) + 63,
              color: mainColor,
              child: const Row(
                children: [],
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 25,
                  child: StaffList(),
                ),
                Flexible(
                  flex: 40,
                  child: StaffAttendance(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
