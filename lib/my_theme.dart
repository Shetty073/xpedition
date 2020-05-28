import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xFFFDFDFD),
  primaryColor: Color(0xFFFF8200),
  secondaryHeaderColor: Color(0xFFECA72C),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFF8200),
    ),
    headline2: TextStyle(
      color: Color(0xFF090C02),
    ),
    bodyText1: TextStyle(
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith();
