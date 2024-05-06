import 'package:flutter/material.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class SLInput extends StatelessWidget {
  final String title, hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color inputColor;
  final Color? bgColor;
  final Color? otherColor;
  final bool isObscure;
  final void Function(String val)? onChanged;
  String? Function(String? val)? validation;
  final bool isOutlined;
  final bool jumpIt;
  final Widget? sufixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final double? width;
  final double? margin;
  final FocusNode? focusNode;
  SLInput(
      {super.key,
      this.isOutlined = false,
      this.inputColor = const Color(0xff898989),
      this.isObscure = false,
      this.readOnly,
      this.otherColor,
      this.validation,
      this.sufixIcon,
      this.onTap,
      this.width,
      this.margin,
      this.focusNode,
      this.onChanged,
      this.jumpIt = false,
      this.bgColor,
      required this.title,
      required this.hint,
      required this.keyboardType,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    validation = validation ??
        (value) {
          if (value!.isEmpty) {
            return "This Field is required.";
          }
          return null;
        };

    return Container(
      width: width,
      margin: margin == null
          ? EdgeInsets.symmetric(horizontal: isOutlined ? 23 : 45)
          : EdgeInsets.symmetric(horizontal: margin!),
      child: TextFormField(
        focusNode: focusNode,
        maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
        readOnly: readOnly ?? false,
        onTap: onTap,
        onChanged: onChanged,
        validator: jumpIt ? null : validation,
        obscureText: isObscure,
        style: TextStyle(color: inputColor),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          fillColor: bgColor ?? mainBgColor,
          filled: true,
          errorBorder: isOutlined
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
          focusedErrorBorder: isOutlined
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
          enabledBorder: isOutlined
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: otherColor ?? inputColor),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: otherColor ?? inputColor),
                ),
          focusedBorder: isOutlined
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: mainBoldColor),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(color: mainBoldColor),
                ),
          suffixIcon: sufixIcon,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }
}
