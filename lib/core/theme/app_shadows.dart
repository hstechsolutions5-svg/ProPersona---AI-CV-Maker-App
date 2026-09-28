import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x0D101828), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x14101828), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x1A101828), blurRadius: 36, offset: Offset(0, 12)),
  ];
}
