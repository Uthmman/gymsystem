import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/Pages/add_member.dart';
import 'package:gymsystem/controller/main_controller.dart';
import '../constants.dart';
import '../widget/sl_input.dart';

class MemberSearch extends StatefulWidget {
  const MemberSearch({super.key});

  @override
  State<MemberSearch> createState() => _MemberSearchState();
}

class _MemberSearchState extends State<MemberSearch> {
  MainController mainController = Get.find<MainController>();

  final TextEditingController _searchTc = TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 11,
        right: 30,
        left: 30,
      ),
      // constraints: BoxConstraints(
      //   minHeight: MediaQuery.of(context).size.height,
      // ),
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
        ],
      ),
    );
  }
}
