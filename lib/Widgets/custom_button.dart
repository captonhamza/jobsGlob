import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final double? textSize;
  final double? buttonHight;
  const CustomButton(
      {super.key, this.buttonHight, this.onPressed, this.text, this.textSize});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      height: buttonHight ?? null,
      color: Colors.orange,
      onPressed: onPressed,
      child: Text(text!,
          style: TextStyle(
              fontSize: textSize ?? 14, color: Colors.white)),
    );
  }
}
