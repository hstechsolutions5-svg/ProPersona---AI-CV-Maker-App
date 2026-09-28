import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  static const double pill = 999;

  static BorderRadius get small => BorderRadius.circular(sm);

  static BorderRadius get medium => BorderRadius.circular(md);

  static BorderRadius get large => BorderRadius.circular(lg);

  static BorderRadius get extraLarge => BorderRadius.circular(xl);
}
