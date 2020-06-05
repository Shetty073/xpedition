import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpedition/homepage/views/plans_view.dart';
import 'package:xpedition/homepage/views/settings_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/initial_setup_page/initial_setup_page.dart';
import 'package:xpedition/create_new_plan/create_new_plan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currPageIndex;
  SharedPreferences myPref;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  void pageChanged(int index) {
    setState(() {
      currPageIndex = index;
      if(currPageIndex == 1) {
        if(!myPref.containsKey("complete_init_setup")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InitialSetupPage()));
        }
      }
    });
  }

  void initSharedPref() async {
    myPref = await SharedPreferences.getInstance();
    myPref.setBool("app_init", true);
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
    currPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: <Widget>[
            PlansView(),
            SettingsView(),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          splashColor: Theme.of(context).secondaryHeaderColor.withAlpha(50),
          child: IconTheme(
            data: IconThemeData(
              color: Colors.white,
            ),
            child: Icon(Icons.add),
          ),
          onPressed: () {
            //TODO: 1. create designs for plans_view, settings_view(with stats) and create_new_plan. 2. implement designs one by one
            // go to create new plan page
            if(!myPref.containsKey("complete_init_setup")) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InitialSetupPage()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPlan(myPref: myPref,)));
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Container(
            padding: EdgeInsets.only(left: 0.15 * deviceWidth, right: 0.15 * deviceWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).textTheme.headline3.color,
                  ),
                  child: IconButton(
                    icon: currPageIndex == 0 ? Icon(Icons.home) : Icon(OMIcons.home),
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
                    icon: currPageIndex == 1 ? Icon(Icons.person) : Icon(OMIcons.person),
                    iconSize: 0.08 * deviceWidth,
                    onPressed: () {
                      // settings view
                      setState(() {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
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

