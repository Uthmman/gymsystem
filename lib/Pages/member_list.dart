import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/add_member.dart';

class MemberList extends StatelessWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<String> memberNames = ['Alice Johnson', 'Bob Smith', 'Eva Brown'];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (context) => const AddMember());
        },
      ),
      body: ListView.builder(
        itemCount: memberNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(memberNames[index]),
            // Add more details about each member here
          );
        },
      ),
    );
  }
}
