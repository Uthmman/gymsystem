import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_member.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:random_avatar/random_avatar.dart';

import '../constants.dart';
import '../widget/sl_input.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool isLoading = false;
  MainController mainController = Get.find<MainController>();

  final TextEditingController _searchTc = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLoading = true;
    setState(() {});
    // List<Member> member = [];
    // for (int i = 0; i < 30; i++) {
    //   member.add(Member(
    //     lastAttendance: DateTime.now().toString(),
    //     fullName: generateRandomString(),
    //     gender: i % 2 == 0 ? "Male" : "Female",
    //     phone: generateRandomInt().toString(),
    //     rfid: generateRandomInt(),
    //     lastPaymentDate: DateTime.now().toString(),
    //     lastPaymentType: "lastPaymentType",
    //     registryDate: DateTime.now().toString(),
    //   )
    // Staff(
    //     fullName: generateRandomString(),
    //     role: generateRandomString(),
    //     startedWorkingFrom: generateRandomString(),
    //     phone: generateRandomInt().toString(),
    //     isActive: 1,
    //     rfId: generateRandomInt(),
    //     entranceTime: DateFormat.jm().format(DateTime.now()),
    //     exitTime: DateFormat.jm().format(DateTime.now()),
    //     lastAttendance: DateTime.now().toString(),
    //     gender: i % 2 == 0 ? "Male" : "Female",
    //     defaultAttendance: AttendanceType.absent,
    //     dateOfBirth: DateTime.now()
    //         .subtract(Duration(days: 360 * (20 + i)))
    //         .toString()),
    // );
    // }

    mainController.getMembers();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 11,
        right: 30,
        left: 30,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child:
          // floatingActionButton: FloatingActionButton(
          //   child: const Icon(Icons.add),
          //   onPressed: () {
          //     showDialog(context: context, builder: (context) => const AddStaff())
          //         .then((value) {
          //       setState(() {});
          //     });
          //   },
          // ),
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 20,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  color: mainBoldColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Member List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "New Member",
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => const AddMember(),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.black26,
          ),
          const SizedBox(
            height: 14.65,
          ),
          SLInput(
            title: "Search Member",
            hint: "",
            keyboardType: TextInputType.text,
            controller: _searchTc,
            isOutlined: true,
            inputColor: Colors.black,
            otherColor: Colors.black26,
          ),
          const SizedBox(
            height: 14.65,
          ),
          isLoading
              ? const Center(
                  child: Text("Loading..."),
                )
              : mainController.members.isEmpty
                  ? const Center(child: Text("Empty Member"))
                  : Column(
                      children: List.generate(
                        mainController.members.length,
                        (index) => Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddMember(
                                  member: mainController.members[index],
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 15,
                            ),
                            title: Text(mainController.members[index].fullName),
                            subtitle: Text(
                                mainController.members[index].lastPaymentType),
                            leading: RandomAvatar(
                              mainController.members[index].fullName,
                              height: 50,
                              width: 50,
                            ),
                            trailing: Text(mainController.members[index].phone),
                            // Add more details about each staff member here
                          ),
                        ),
                      ),
                    )

          // Expanded(
          //     child: ListView.builder(
          //       itemCount: DatabaseHelper.staffs.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Text(DatabaseHelper.staffs[index].fullName),
          //           subtitle: Text(DatabaseHelper.staffs[index].role),
          //           leading: RandomAvatar(
          //             DatabaseHelper.staffs[index].fullName,
          //             height: 50,
          //             width: 50,
          //           ),
          //           trailing: Text(DatabaseHelper.staffs[index].phone),
          //           // Add more details about each staff member here
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }
}
