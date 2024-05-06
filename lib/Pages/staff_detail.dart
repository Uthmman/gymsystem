import 'package:flutter/material.dart';

class StaffDetail extends StatefulWidget {
  const StaffDetail({super.key});

  @override
  State<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends State<StaffDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 3,
        vertical: 50,
      ),
      child:  Scaffold(
        appBar: AppBar(
         
        ),
      ),
    );
  }
}
