// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymsystem/constants.dart';

class NavDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  const NavDrawer({super.key, required this.onItemSelected});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
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
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            'assets/connect logo.svg',
            height: 30,
            width: 30,
            color: Colors.white,
          ),
          const SizedBox(
            height: 40,
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
          const Spacer(),
          IconButton(
            tooltip: "Developed by ENSRA TECH\nPhone No: 0960216060",
            onPressed: () {
              // showCustomTooltip(context);
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Developed by ENSRA TECH\nPhone No: 0960216060",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
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
