import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xFFEEEFF0),
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
    headline4: TextStyle(
      color: Color(0xFFF5F5F5),
    ),
    headline5: TextStyle(
      color: Color(0xFF9E9E9E),
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
  scaffoldBackgroundColor: Color(0xFF252525),
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
    headline4: TextStyle(
      color: Color(0xFF1B1B1B),
    ),
    headline5: TextStyle(
      color: Color(0xFF1B1B1B),
    ),
    bodyText1: TextStyle(
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),

  ),
);
