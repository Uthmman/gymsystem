import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_staff.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/controller/main_controller.dart';
import 'package:gymsystem/widget/sl_input.dart';

class StaffList extends StatefulWidget {
  const StaffList({
    super.key,
  });

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  MainController mainController = Get.find<MainController>();

  final TextEditingController _searchTc = TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    mainController.getStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
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
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 12,
          //     bottom: 2,
          //     left: 20,
          //   ),
          //   child: Row(
          //     children: [
          //       Image.asset(
          //         'assets/employee.png',
          //         color: mainBoldColor,
          //         width: 30,
          //         height: 30,
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       const Text(
          //         "Staff List",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const Spacer(),
          //       IconButton(
          //         tooltip: "New Staff",
          //         icon: const Icon(Icons.add),
          //         onPressed: () async {
          //           await showDialog(
          //             context: context,
          //             builder: (context) => const AddStaff(),
          //           );
          //         },
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       )
          //     ],
          //   ),
          // ),
          // const Divider(
          //   color: Colors.black26,
          // ),
          // const SizedBox(
          //   height: 14.65,
          // ),
          // SLInput(
          //   title: "Search Staffs",
          //   hint: "",
          //   focusNode: _searchFocus,
          //   keyboardType: TextInputType.text,
          //   controller: _searchTc,
          //   isOutlined: true,
          //   inputColor: Colors.black,
          //   otherColor: Colors.black26,
          //   sufixIcon: isSearching
          //       ? GestureDetector(
          //           onTap: () {
          //             _searchTc.text = "";
          //             isSearching = false;
          //             _searchFocus.unfocus();
          //             mainController.getStaff();
          //             setState(() {});
          //           },
          //           child: const Icon(Icons.close),
          //         )
          //       : null,
          //   onChanged: (val) {
          //     if (isSearching == false && val.isNotEmpty) {
          //       setState(() {
          //         isSearching = true;
          //       });
          //     }
          //     mainController.searchStaff(val);
          //   },
          // ),
          // const SizedBox(
          //   height: 14.65,
          // ),
          Obx(() {
            return mainController.staffs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text("Empty Staff"),
                    ),
                  )
                : Column(
                    children: List.generate(
                      mainController.staffs.length,
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
                              builder: (context) => AddStaff(
                                staff: mainController.staffs[index],
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 15,
                          ),
                          title: Text(mainController.staffs[index].fullName),
                          subtitle: Text(mainController.staffs[index].role),
                          // Container(
                          //   height: 130,
                          //   width: 130,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     image: DecorationImage(
                          //       fit: BoxFit.cover,
                          //       image: FileImage(
                          //         File(widget.image),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: mainController
                                      .staffs[index].image.isNotEmpty
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(
                                            mainController.staffs[index].image),
                                      ),
                                    )
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          mainController.staffs[index].gender ==
                                                  'Male'
                                              ? const AssetImage(
                                                  'assets/male.jpg',
                                                )
                                              : const AssetImage(
                                                  'assets/female.jpg'),
                                    ),
                            ),
                          ),
                          trailing: Text(mainController.staffs[index].phone),
                          // Add more details about each staff member here
                        ),
                      ),
                    ),
                  );
          })

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
