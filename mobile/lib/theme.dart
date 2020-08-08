import 'package:flutter/material.dart';

const primaryColor = Color(0xff5d6abe);
const shadownColor = Color(0xff5E6CB1);

class ColorTheme {
  static const MaterialColor primarySwatchColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFecedf7),
      100: Color(0xFFced2ec),
      200: Color(0xFFaeb5df),
      300: Color(0xFF8e97d2),
      400: Color(0xFF7580c8),
      500: Color(0xFF5d6abe),
      600: Color(0xFF5562b8),
      700: Color(0xFF4b57af),
      800: Color(0xFF414da7),
    },
  );
  static const int _primaryValue = 0xFF5d6abe;
}
