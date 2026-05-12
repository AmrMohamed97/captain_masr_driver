import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xffBA060E);
  static const Color textColor = Color(0xff141414);
  static const Color greyText = Color(0xffB3B3B3);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff0C0C0C);
  static const Color grey = Color(0xffD9D9D9);
  static const Color grey2 = Color(0xffF4F4F4);
  static const Color grey3 = Color(0xffF2F2F2);
  static const Color grey4 = Color(0xffF8F8F8);
  static const Color grey5 = Color(0xffF0F0F0);
  static const Color strokColor = Color(0xffFCFCFC);
  static const Color green = Color(0xff038A37);
  static const Color red = Color(0xffD02828);
  static const Color red2 = Color(0xffC64949);
  static const Color yellow = Color(0xffF9A71A);
  static const Color transparent = Colors.transparent;

  static Gradient primaryGradient = const LinearGradient(
    colors: [AppColors.red2, Color(0xffBA060E)],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );
}
