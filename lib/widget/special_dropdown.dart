import 'package:flutter/material.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class SpecialDropdown<T> extends StatefulWidget {
  final String title;
  final double? margin;
  final double width;
  final T value;
  final List<T> list;
  final Color? bgColor;
  final Color? titleColor, textColor;
  final bool noTitle, isDense;
  final bool isOutLined;
  final void Function(dynamic value) onChange;
  List<DropdownMenuItem<T>>? items;
  SpecialDropdown(
      {super.key,
      required this.title,
      this.margin,
      required this.value,
      required this.width,
      required this.list,
      required this.onChange,
      this.items,
      this.bgColor,
      this.titleColor,
      this.noTitle = false,
      this.isDense = false,
      this.textColor,
      this.isOutLined = false});

  @override
  // ignore: no_logic_in_create_state
  State<SpecialDropdown<T>> createState() => _SpecialDropdownState<T>(list);
}

class _SpecialDropdownState<T> extends State<SpecialDropdown<T>> {
  final List<T> list;
  _SpecialDropdownState(this.list);
  @override
  Widget build(BuildContext context) {
    widget.items ??= list
        .map(
          (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                e.toString(),
                style: TextStyle(color: widget.textColor),
              )),
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.margin ?? 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.noTitle)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.title,
                style: TextStyle(color: widget.titleColor ?? textColor),
              ),
            ),
          if (!widget.noTitle)
            const SizedBox(
              height: 10,
            ),
          Container(
            width: widget.width,
            decoration: BoxDecoration(
                color: widget.bgColor ?? mainBgColor,
                border: widget.isOutLined ? Border.all(color: textColor) : null,
                borderRadius:
                    BorderRadius.circular(widget.isOutLined ? 15 : 15)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                padding: const EdgeInsets.symmetric(vertical: 4),
                value: widget.value,
                isDense: widget.isDense,
                icon: const Icon(Icons.keyboard_arrow_down),
                dropdownColor: mainBgColor,
                iconEnabledColor: textColor,
                items: widget.items,
                onChanged: widget.onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
