import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/create_new_plan/create_new_plan.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/homepage/views/completed_plans_view.dart';
import 'package:xpedition/homepage/views/plans_view.dart';
import 'package:xpedition/homepage/views/settings_view.dart';

class HomePage extends StatefulWidget {
  final UserDataWithId myUserDataWithId;
  final List<VehicleDataWithId> vehicleDataWithIdList;

  HomePage(
      {@required this.myUserDataWithId, @required this.vehicleDataWithIdList});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currPageIndex;
  SharedPreferences _myPref;
  List<VehicleDataWithId> _myVehicleDataWithIdList;
  UserDataWithId _myUserDataWithId;
  DatabaseHelper _myDbHelper;
  bool _updateVehicleDataFlag = false;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  PageController _pageController = PageController(
    initialPage: 0,
  );

  void _pageChanged(int index) {
    setState(() {
      _currPageIndex = index;
    });
  }

  void _initSharedPref() async {
    _myPref = await SharedPreferences.getInstance();
    _myPref.setBool("app_init", true);
  }

  void _displayCloudMessagingAlert(
      Map<String, dynamic> message, double deviceWidth, double deviceHeight) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message["notification"]["title"],
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          content: Text(
            message["notification"]["body"],
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          actions: <Widget>[
            ButtonTheme(
              child: FlatButton(
                color: Theme.of(context).textTheme.headline1.color,
                textColor: Colors.white,
                splashColor:
                    Theme.of(context).textTheme.headline1.color.withAlpha(50),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Okay",
                  style: GoogleFonts.montserrat(
                    fontSize: 0.04 * deviceWidth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateData() async {
    _updateVehicleDataFlag = true;
    List<UserDataWithId> _myUserDataWithIdList =
        await _myDbHelper.getUserData();
    _myUserDataWithId = _myUserDataWithIdList[0];
    _myVehicleDataWithIdList = await _myDbHelper.getVehicleData();
  }

  @override
  void initState() {
    super.initState();
    _initSharedPref();
    if (!_updateVehicleDataFlag) {
      _myVehicleDataWithIdList = widget.vehicleDataWithIdList;
    }
    _myUserDataWithId = widget.myUserDataWithId;
    _currPageIndex = 0;
    _myDbHelper = DatabaseHelper();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _displayCloudMessagingAlert(message, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            (_currPageIndex == 0) ? "Xpedition" : "Settings",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            (_currPageIndex == 0)
                ? GestureDetector(
                    onTap: () {
                      // TODO: goto finished trips page
                      _myDbHelper.getCompletedPlanData().then(
                            (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompletedPlansView(
                                  completedPlanDataList: value,
                                ),
                              ),
                            ),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 0.001 * deviceWidth,
                        ),
                      ),
                      padding: EdgeInsets.only(
                        right: 0.015 * deviceWidth,
                        top: 0.0,
                        bottom: 0.0,
                        left: 0.015 * deviceWidth,
                      ),
                      margin: EdgeInsets.only(
                        right: 0.015 * deviceWidth,
                        top: 0.03 * deviceWidth,
                        bottom: 0.03 * deviceWidth,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Completed",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(
                              Icons.archive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        body: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            _pageChanged(index);
          },
          children: <Widget>[
            PlansView(),
            SettingsView(
              myUserDataWithId: _myUserDataWithId,
              vehicleDataWithIdList: _myVehicleDataWithIdList,
              callBackFunction: _updateData,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (_currPageIndex == 0)
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                splashColor:
                    Theme.of(context).secondaryHeaderColor.withAlpha(50),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.white,
                  ),
                  child: Icon(Icons.add),
                ),
                onPressed: () {
                  // go to create new plan page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewPlan(
                        myPref: _myPref,
                      ),
                    ),
                  );
                },
              )
            : null,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Container(
            padding: EdgeInsets.only(
                left: 0.15 * deviceWidth, right: 0.15 * deviceWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).textTheme.headline3.color,
                  ),
                  child: IconButton(
                    icon: _currPageIndex == 0
                        ? Icon(Icons.home)
                        : Icon(OMIcons.home),
                    iconSize: 0.08 * deviceWidth,
                    onPressed: () {
                      // plans list view

                      setState(() {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    },
                  ),
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).textTheme.headline3.color,
                  ),
                  child: IconButton(
                    icon: _currPageIndex == 1
                        ? Icon(Icons.person)
                        : Icon(OMIcons.person),
                    iconSize: 0.08 * deviceWidth,
                    onPressed: () {
                      // settings view
                      setState(
                        () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
