import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:jobs_global/Utils/global.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final dynamic validate;
  final bool? paswordVisble;
  final bool? isReadOnly;
  Function()? onTap;
  CustomTextFieldWidget(
      {super.key,
      this.hintText,
      this.prefixIcon,
      this.controller,
      this.inputType,
      this.validate,
      this.paswordVisble,
      this.isReadOnly,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: isReadOnly == null ? false : isReadOnly!,
      obscureText: paswordVisble ?? false,
      controller: controller,
      keyboardType: inputType,
      validator: validate,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: 2, horizontal: prefixIcon == null ? 15 : 0),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.goldenColor)),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(
                  prefixIcon,
                  color: AppColor.goldenColor,
                ),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.black26, fontWeight: FontWeight.normal),
          errorStyle: TextStyle(height: 0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.goldenColor))),
    );
  }
}
