import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xFFFDFDFD),
  primaryColor: Color(0xFFFF8200),
  accentColor: Color(0xFFECA72C),
  splashColor: Color(0xFFECA72C),
  secondaryHeaderColor: Color(0xFFECA72C),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFF8200),
    ),
    headline2: TextStyle(
      color: Color(0xFF090C02),
    ),
    headline3: TextStyle(
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFF1F2227),
  primaryColor: Color(0xFFFF8200),
  accentColor: Color(0xFFECA72C),
  splashColor: Color(0xFFECA72C),
  secondaryHeaderColor: Color(0xFFECA72C),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFF8200),
    ),
    headline2: TextStyle(
      color: Colors.white,
    ),
    headline3: TextStyle(
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),
  ),
);
