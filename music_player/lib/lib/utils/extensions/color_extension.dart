import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get getContrastColor =>
      computeLuminance() > 0.279 ? const Color(0xFF16161d) : Colors.white;
}
