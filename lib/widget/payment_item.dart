import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/model/payment.dart';
import 'package:intl/intl.dart';

class PaymentItem extends StatefulWidget {
  final Payment payment;
  final VoidCallback? onEdit;
  const PaymentItem({
    super.key,
    required this.payment,
    this.onEdit,
  });

  @override
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              widget.onEdit != null
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 15,
                          color: mainBoldColor,
                        ),
                        onPressed: widget.onEdit,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.receipt,
                      size: 30,
                      color: mainBoldColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("From: ${DateFormat("MMM dd/yyyy").format(
                      DateTime.parse(widget.payment.startingDate),
                    )}"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("to: ${DateFormat("MMM dd/yyyy").format(
                      DateTime.parse(widget.payment.endingDate),
                    )}")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
