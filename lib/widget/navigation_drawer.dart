// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  NavDrawer({super.key, required this.onItemSelected});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int index = 0;

  // const NavigationDrawer({Key? key, required this.onItemSelected})
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(14, 0, 0, 0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Gym Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            tileColor: index == 0 ? Colors.blue.shade100 : null,
            title: const Text('Staffs'),
            onTap: () {
              widget.onItemSelected(0);
              setState(() {
                index = 0;
              });

              // Navigator.pop(context);
            },
          ),
          ListTile(
            tileColor: index == 1 ? Colors.blue.shade100 : null,
            title: const Text('Members'),
            onTap: () {
              widget.onItemSelected(1);
              setState(() {
                index = 1;
              });
              // Navigator.pop(context);
            },
          ),
          ListTile(
            tileColor: index == 2 ? Colors.blue.shade100 : null,
            title: const Text('Score'),
            onTap: () {
              widget.onItemSelected(2);
              setState(() {
                index = 2;
              });
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
