import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_member.dart';
import 'package:gymsystem/controller/main_controller.dart';
import '../constants.dart';
import 'sl_input.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  MainController mainController = Get.find<MainController>();

  final TextEditingController _searchTc = TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  bool isSearching = false;
  @override
  void initState() {
    super.initState();

    mainController.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        // top: MediaQuery.of(context).size.height / 11,
        right: 30,
        left: 30,
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.vertical(
        //   top: Radius.circular(15),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            return mainController.members.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text("Empty Members"),
                    ),
                  )
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
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image:
                                  mainController.members[index].image.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(mainController
                                                .members[index].image),
                                          ),
                                        )
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: mainController
                                                      .members[index].gender ==
                                                  'Male'
                                              ? const AssetImage(
                                                  'assets/male.jpg',
                                                )
                                              : const AssetImage(
                                                  'assets/female.jpg'),
                                        ),
                            ),
                          ),
                          trailing: Text(mainController.members[index].phone),
                          // Add more details about each staff member here
                        ),
                      ),
                    ),
                  );
          })
        ],
      ),
    );
  }
}
