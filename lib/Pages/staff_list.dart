import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/add_staff.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:random_avatar/random_avatar.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    setState(() {});
    List<Staff> staffs = [];
    for (int i = 0; i < 30; i++) {
      staffs.add(
        Staff(
          fullName: generateRandomString(),
          role: generateRandomString(),
          startedWorkingFrom: generateRandomString(),
          phone: generateRandomInt().toString(),
          isActive: 1,
          shiftType: "Regular",
          rfId: generateRandomInt(),
        ),
      );
    }
    DatabaseHelper.staffs = staffs;
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
          const Padding(
            padding: EdgeInsets.only(
              top: 19,
              bottom: 9,
              left: 20,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  color: mainColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Staff List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black26,
          ),
          const SizedBox(
            height: 60,
          ),
          isLoading
              ? const Center(
                  child: Text("Loading..."),
                )
              : DatabaseHelper.staffs.isEmpty
                  ? const Center(child: Text("Empty Staff"))
                  : Column(
                      children: List.generate(
                        DatabaseHelper.staffs.length,
                        (index) => Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          child: ListTile(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   vertical: 10,
                            // ),
                            title: Text(DatabaseHelper.staffs[index].fullName),
                            subtitle: Text(DatabaseHelper.staffs[index].role),
                            leading: RandomAvatar(
                              DatabaseHelper.staffs[index].fullName,
                              height: 50,
                              width: 50,
                            ),
                            trailing: Text(DatabaseHelper.staffs[index].phone),
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
