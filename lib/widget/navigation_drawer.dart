// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';

class NavDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  const NavDrawer({super.key, required this.onItemSelected});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // int index = 0;

  // const NavigationDrawer({Key? key, required this.onItemSelected})
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: mainBoldColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      // color: const Color.fromARGB(14, 0, 0, 0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: mainColor,
          //   ),
          //   child: Text(
          //     'Gym Management',
          //     style: TextStyle(
          //       fontSize: 24,
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 60,
          ),
          IconButton(
            tooltip: "Staffs",
            icon: Image.asset(
              'assets/employee.png',
              color: Colors.white,
              width: 30,
              height: 30,
            ),
            onPressed: () {
              widget.onItemSelected(0);
              // setState(() {
              //   index = 0;
              // });

              // Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            tooltip: "Members",
            icon: const Icon(
              Icons.people_alt,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              widget.onItemSelected(1);
              // setState(() {
              //   index = 1;
              // });
              // Navigator.pop(context);
            },
          ),
          // ListTile(
          //   // tileColor: index == 2 ? Colors.blue.shade100 : null,
          //   title: const Icon(Icons.),
          //   subtitle: const Text('Score'),
          //   onTap: () {
          //     widget.onItemSelected(2);
          //     // setState(() {
          //     //   index = 2;
          //     // });
          //     // Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
