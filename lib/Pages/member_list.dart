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
      child: Column(
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
            title: "Search Members",
            hint: "",
            focusNode: _searchFocus,
            keyboardType: TextInputType.text,
            controller: _searchTc,
            isOutlined: true,
            inputColor: Colors.black,
            otherColor: Colors.black26,
            sufixIcon: isSearching
                ? GestureDetector(
                    onTap: () {
                      _searchTc.text = "";
                      isSearching = false;
                      _searchFocus.unfocus();
                      mainController.getMembers();
                      setState(() {});
                    },
                    child: const Icon(Icons.close),
                  )
                : null,
            onChanged: (val) {
              if (isSearching == false && val.isNotEmpty) {
                setState(() {
                  isSearching = true;
                });
              }
              mainController.searchMembers(val);
            },
          ),
          const SizedBox(
            height: 14.65,
          ),
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
                              image: DecorationImage(
                                image: mainController.members[index].gender ==
                                        'Male'
                                    ? const AssetImage(
                                        'assets/male.jpg',
                                      )
                                    : const AssetImage('assets/female.jpg'),
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
