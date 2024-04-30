import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/add_staff.dart';
import 'package:gymsystem/helper/db_helper.dart';

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
    DatabaseHelper().getStaffs().then((value) {
      DatabaseHelper.staffs = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (context) => const AddStaff())
              .then((value) {
            setState(() {});
          });
        },
      ),
      body: isLoading
          ? const Center(
              child: Text("Loading..."),
            )
          : DatabaseHelper.staffs.isEmpty
              ? const Center(child: Text("Empty Staff"))
              : ListView.builder(
                  itemCount: DatabaseHelper.staffs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DatabaseHelper.staffs[index].fullName),
                      subtitle: Text(DatabaseHelper.staffs[index].role),
                      leading: const Icon(Icons.account_circle),
                      trailing:
                          Text(DatabaseHelper.staffs[index].phone),
                      // Add more details about each staff member here
                    );
                  },
                ),
    );
  }
}
