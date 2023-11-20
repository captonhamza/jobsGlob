import 'dart:core';

import 'package:flutter/material.dart';

class CustomTitlewithData extends StatelessWidget {
  String? title;
  String? data;
  CustomTitlewithData(
    this.title,
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data == null || data!.isEmpty ? "---" : data!,
            style: const TextStyle(),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            title!,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomHeaderTitle extends StatelessWidget {
  String? title;
  CustomHeaderTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 25),
      child: Text(
        title!,
        style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.teal),
      ),
    );
  }
}
