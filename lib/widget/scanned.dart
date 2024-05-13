import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/controller/main_controller.dart';

class Scanned extends StatefulWidget {
  final String messege;
  final VoidCallback onTap;
  final String image;

  final String gender;
  const Scanned({
    super.key,
    required this.messege,
    required this.onTap,
    required this.image,
    required this.gender,
  });

  @override
  State<Scanned> createState() => _ScannedState();
}

class _ScannedState extends State<Scanned> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500)).then((value) {
      if (Get.find<MainController>().location == Location.main) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            spreadRadius: 15,
            blurRadius: 19,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: widget.image.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(widget.image),
                      ),
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.gender == 'Male'
                          ? const AssetImage(
                              'assets/male.jpg',
                            )
                          : const AssetImage('assets/female.jpg'),
                    ),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          Text(
            widget.messege,
            style: const TextStyle(
              fontSize: 19,
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          TextButton(
            onPressed: widget.onTap,
            child: const Text("Show details"),
          )
        ],
      ),
    );
  }
}
