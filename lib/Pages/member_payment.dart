import 'package:flutter/material.dart';
import 'package:gymsystem/Pages/add_payment.dart';

class MemberPayment extends StatefulWidget {
  const MemberPayment({super.key});

  @override
  State<MemberPayment> createState() => _MemberPaymentState();
}

class _MemberPaymentState extends State<MemberPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddPayment(),
          );
        },
      ),
      body: const Center(
        child: Text("MemberPayment"),
      ),
    );
  }
}
