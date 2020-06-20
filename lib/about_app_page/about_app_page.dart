import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppPage extends StatefulWidget {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AboutAppPage({
    @required this.appName,
    @required this.packageName,
    @required this.version,
    @required this.buildNumber,
  });

  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 0.026 * deviceWidth),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "About this app",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 0.03 * deviceWidth,
            right: 0.03 * deviceWidth,
            top: 0.025 * deviceWidth,
            bottom: 0.025 * deviceWidth,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    // NOTE: This is empty on purpose
                  },
                  splashColor: Theme.of(context).textTheme.headline4.color,
                  child: Container(
                    height: 0.08 * deviceHeight,
                    padding: EdgeInsets.only(
                      left: 0.01 * deviceWidth,
                      right: 0.03 * deviceWidth,
                      top: 0.025 * deviceWidth,
                      bottom: 0.025 * deviceWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Developer: ",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 0.04 * deviceWidth,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.05 * deviceWidth,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Ashish Harish Shetty",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 0.04 * deviceWidth,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.01 * deviceWidth,
                              ),
                              Text(
                                "https://www.github.com/Shetty073",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 0.03 * deviceWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).textTheme.bodyText1.color,
                height: 0.02 * deviceWidth,
                thickness: 0.0005 * deviceWidth,
              ),
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    // NOTE: This is empty on purpose
                  },
                  splashColor: Theme.of(context).textTheme.headline4.color,
                  child: Container(
                    height: 0.08 * deviceHeight,
                    padding: EdgeInsets.only(
                      left: 0.01 * deviceWidth,
                      right: 0.03 * deviceWidth,
                      top: 0.025 * deviceWidth,
                      bottom: 0.025 * deviceWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Version:",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 0.04 * deviceWidth,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.05 * deviceWidth,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "${widget.version}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 0.04 * deviceWidth,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).textTheme.bodyText1.color,
                height: 0.02 * deviceWidth,
                thickness: 0.0005 * deviceWidth,
              ),
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    // NOTE: This is empty on purpose
                  },
                  splashColor: Theme.of(context).textTheme.headline4.color,
                  child: Container(
                    height: 0.08 * deviceHeight,
                    padding: EdgeInsets.only(
                      left: 0.01 * deviceWidth,
                      right: 0.03 * deviceWidth,
                      top: 0.025 * deviceWidth,
                      bottom: 0.025 * deviceWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Build number:",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 0.04 * deviceWidth,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.05 * deviceWidth,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "${widget.buildNumber} (beta software)",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 0.04 * deviceWidth,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).textTheme.bodyText1.color,
                height: 0.02 * deviceWidth,
                thickness: 0.0005 * deviceWidth,
              ),
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    // NOTE: This is empty on purpose
                  },
                  splashColor: Theme.of(context).textTheme.headline4.color,
                  child: Container(
                    height: 0.08 * deviceHeight,
                    padding: EdgeInsets.only(
                      left: 0.01 * deviceWidth,
                      right: 0.03 * deviceWidth,
                      top: 0.025 * deviceWidth,
                      bottom: 0.025 * deviceWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Licenses:",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 0.04 * deviceWidth,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.05 * deviceWidth,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Will be added soon....",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 0.04 * deviceWidth,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.05 * deviceWidth,
              ),
              Center(
                child: Text(
                  "This application is still under development",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 0.03 * deviceWidth,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
