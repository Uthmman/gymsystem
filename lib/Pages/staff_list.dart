import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/add_staff.dart';
import 'package:gymsystem/Pages/password_page.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:gymsystem/widget/sl_input.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  bool isLoading = false;

  final TextEditingController _searchTc = TextEditingController();
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
            rfId: generateRandomInt(),
            entranceTime: DateFormat.jm().format(DateTime.now()),
            exitTime: DateFormat.jm().format(DateTime.now()),
            lastAttendance: DateTime.now().toString(),
            gender: i % 2 == 0 ? "Male" : "Female",
            defaultAttendance: AttendanceType.absent,
            dateOfBirth: DateTime.now()
                .subtract(Duration(days: 360 * (20 + i)))
                .toString()),
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
                  "Staff List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "New Staff",
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    bool premission = await showDialog(
                      context: context,
                      builder: (context) => const PasswordPage(),
                    );
                    print("premission: $premission");
                    if (mounted) {
                      if (premission) {
                        showToast(context, "Permission Granted", greenColor);
                      } else {
                        showToast(context, "Permission Denyed", redColor);
                      }
                    }
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
            title: "Search Staffs",
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddStaff(
                                  staff: DatabaseHelper.staffs[index],
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 15,
                            ),
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
