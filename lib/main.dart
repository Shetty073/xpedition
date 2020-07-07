import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpedition/loading_screen/loading_screen.dart';
import 'package:xpedition/my_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Xpedition',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: LoadingScreen(),
    );
  }
}
