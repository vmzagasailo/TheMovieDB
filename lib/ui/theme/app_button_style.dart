import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final ButtonStyle textButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(const Color(0XFF01B4E4)),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}
