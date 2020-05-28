import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/initial_setup_page/initial_setup_page.dart';
import 'package:xpedition/homepage/homepage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  SharedPreferences myPref;

  void checkIfInitSetupComplete() async {
    // using SharedPreferences check whether this is the first time app is opened
    myPref = await SharedPreferences.getInstance();
    bool flag = myPref.containsKey("app_init");
    if (flag) {
      Future.delayed(
          const Duration(microseconds: 1000), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      });
    } else {
      Future.delayed(
          const Duration(microseconds: 800), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => InitialSetupPage(),
        ));
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfInitSetupComplete();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "X",
                    style: GoogleFonts.montserrat(
                      fontSize: 0.122 * deviceWidth,
                      fontWeight: FontWeight.w700,
                      color: Theme
                          .of(context)
                          .textTheme
                          .headline1
                          .color,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "pedition",
                        style: GoogleFonts.montserrat(
                          fontSize: 0.1 * deviceWidth,
                          fontWeight: FontWeight.w700,
                          color: Theme
                              .of(context)
                              .textTheme
                              .headline2
                              .color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpinKitWave(
                color: Theme
                    .of(context)
                    .primaryColor,
                size: 0.1 * deviceWidth,
              ),
            ],
          ),
        ),
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
      ),
    );
  }
}

