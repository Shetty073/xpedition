import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:xpedition/about_app_page/about_app_page.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/view_edit_plan_page/update_initial_settings_page.dart';

class SettingsView extends StatefulWidget {
  final UserDataWithId myUserDataWithId;
  final List<VehicleDataWithId> vehicleDataWithIdList;
  final VoidCallback callBackFunction;

  SettingsView(
      {@required this.myUserDataWithId,
      @required this.vehicleDataWithIdList,
      @required this.callBackFunction});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  UserDataWithId _myUserDataWithId;
  List<VehicleDataWithId> _myVehicleDataWithIdList;

  @override
  void initState() {
    super.initState();
    _myUserDataWithId = widget.myUserDataWithId;
    _myVehicleDataWithIdList = widget.vehicleDataWithIdList;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 0.025 * deviceWidth,
        right: 0.025 * deviceWidth,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateInitialSettingsPage(
                      userDataWithId: _myUserDataWithId,
                      callBackFunction: widget.callBackFunction,
                      vehicleDataWithIdList: _myVehicleDataWithIdList,
                    ),
                  ),
                );
              },
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.12 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.03 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 0.08 * deviceWidth,
                      backgroundImage: NetworkImage(
                          "https://api.adorable.io/avatars/285/${_myUserDataWithId.firstName}${_myUserDataWithId.lastName}@adorable.io.png"),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${_myUserDataWithId.firstName} ${_myUserDataWithId.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 0.05 * deviceWidth,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.01 * deviceWidth,
                          ),
                          Text(
                            "Initial user data",
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
            thickness: 0.001 * deviceWidth,
          ),
          SizedBox(
            height: 0.02 * deviceWidth,
          ),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () {
                FlutterToast.showToast(
                    msg: "Coming soon...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 16.0);
              },
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.08 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.046 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        size: 0.1 * deviceWidth,
                      ),
                      child: Icon(
                        Icons.data_usage,
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Visualize data",
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
                            "Have a look at the graphical representation of your data",
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
          SizedBox(
            height: 0.001 * deviceWidth,
          ),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () {
                FlutterToast.showToast(
                    msg: "Coming soon...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 16.0);
              },
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.08 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.046 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        size: 0.1 * deviceWidth,
                      ),
                      child: Icon(
                        Icons.file_download,
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Export data",
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
                            "Export your data as a .csv file for spreadsheets",
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
          SizedBox(
            height: 0.001 * deviceWidth,
          ),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () {
                FlutterToast.showToast(
                    msg: "Coming soon...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 16.0);
              },
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.08 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.046 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        size: 0.1 * deviceWidth,
                      ),
                      child: Icon(
                        Icons.backup,
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Backup settings",
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
                            "Manage your data backup settings",
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
          SizedBox(
            height: 0.001 * deviceWidth,
          ),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () {
                PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                  String appName = packageInfo.appName;
                  String packageName = packageInfo.packageName;
                  String version = packageInfo.version;
                  String buildNumber = packageInfo.buildNumber;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutAppPage(
                        appName: appName,
                        packageName: packageName,
                        version: version,
                        buildNumber: buildNumber,
                      ),
                    ),
                  );
                });
              },
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.08 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.046 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        size: 0.1 * deviceWidth,
                      ),
                      child: Icon(
                        Icons.info_outline,
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "About this app",
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
                            "Developer and license information",
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
        ],
      ),
    );
  }
}
