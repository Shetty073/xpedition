import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/create_new_plan/views/plan_form_view_one.dart';
import 'package:xpedition/create_new_plan/views/plan_form_view_two.dart';
import 'package:xpedition/create_new_plan/views/plan_form_view_three.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/vehicle_data.dart';
import 'package:xpedition/database_helper/database_helper.dart';

class CreateNewPlan extends StatefulWidget {
  final SharedPreferences myPref;

  CreateNewPlan({@required this.myPref});

  @override
  _CreateNewPlanState createState() => _CreateNewPlanState();
}

class _CreateNewPlanState extends State<CreateNewPlan> {
  DatabaseHelper _myDbHelper;
  List<VehicleData> _myVehicleData;
  int currPageIndex;

  TextEditingController _fromLocationController,
      _toLocationController,
      _distanceController,
      _dateController,
      _noOfDaysController,
      _vehicleNameController,
      _fuelMileageController,
      _fuelCostController;

  final _formKey = GlobalKey<FormState>();

  PageController _pageController = PageController(
    initialPage: 0,
  );

  void pageChanged(int index) {
    setState(() {
      currPageIndex = index;
    });
  }

  void _getVehicleDetails() async {
    _myVehicleData = await _myDbHelper.getVehicleData();
  }

  @override
  void initState() {
    super.initState();
    currPageIndex = 0;
    _fromLocationController = TextEditingController();
    _toLocationController = TextEditingController();
    _distanceController = TextEditingController();
    _dateController = TextEditingController();
    _noOfDaysController = TextEditingController();
    _vehicleNameController = TextEditingController();
    _fuelMileageController = TextEditingController();
    _fuelCostController = TextEditingController();
    _myDbHelper = DatabaseHelper();
    _myVehicleData = [];
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          if (currPageIndex == 0) {
                            Navigator.pop(context);
                          } else {
                            _pageController.animateToPage(--currPageIndex,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        }),
                    SizedBox(
                      width: 0.1 * deviceWidth,
                    ),
                    Text(
                      "Create a new plan",
                      style: GoogleFonts.montserrat(
                        fontSize: 0.06 * deviceWidth,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.82 * deviceHeight,
                child: Form(
                  key: _formKey,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      pageChanged(index);
                    },
                    children: <Widget>[
                      PlanFormViewOne(
                        fromLocationController: _fromLocationController,
                        toLocationController: _toLocationController,
                        distanceController: _distanceController,
                        myPref: widget.myPref,
                      ),
                      PlanFormViewTwo(
                        dateController: _dateController,
                        noOfDaysController: _noOfDaysController,
                      ),
                      PlanFormViewThree(
                        fromLocationController: _fromLocationController,
                        toLocationController: _toLocationController,
                        vehicleNameController: _vehicleNameController,
                        fuelMileageController: _fuelMileageController,
                        fuelCostController: _fuelCostController,
                        myVehicleData: _myVehicleData,
                        myFormKey: _formKey,
                        myPref: widget.myPref,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.06 * deviceHeight,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0.41 * deviceWidth, top: 0.06 * deviceWidth),
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 3,
                          effect: ScrollingDotsEffect(
                            dotColor: Colors.grey,
                            activeDotColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    currPageIndex == 2
                        ? Container()
                        : Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 0.18 * deviceHeight),
                              child: IconButton(
                                icon: Icon(
                                  Icons.navigate_next,
                                  size: 0.12 * deviceWidth,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  if (currPageIndex == 0) {
                                    if (_formKey.currentState.validate() &&
                                        _fromLocationController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _toLocationController.text
                                            .trim()
                                            .isNotEmpty) {
                                      setState(() {
                                        _getVehicleDetails();
                                        _pageController.animateToPage(
                                            ++currPageIndex,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _pageController.animateToPage(
                                            ++currPageIndex,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }
                                  }
                                },
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
    );
  }
}
