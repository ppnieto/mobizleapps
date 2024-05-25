import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MbzNoElements extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? textStyle;

  const MbzNoElements({super.key, required this.title, this.subtitle, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(child: Icon(Icons.info_outline_rounded, size: 48), minRadius: 50).paddingAll(20),
        Text(title, style: textStyle).paddingOnly(bottom: 20),
        if (subtitle != null) Text(subtitle!, style: textStyle),
      ],
    );
  }
}
