import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/member_attendance.dart';

import '../constants.dart';
import '../controller/main_controller.dart';
import 'member_list.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Management'),
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
          )
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
                  child: MemberList(),
                ),
                Flexible(
                  flex: 40,
                  child: MemberAttendance(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
