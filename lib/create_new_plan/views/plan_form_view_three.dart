import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/data_models/new_plan_data.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/homepage/homepage.dart';

class PlanFormViewThree extends StatefulWidget {
  final TextEditingController fromLocationController,
      toLocationController,
      distanceController,
      dateController,
      noOfDaysController,
      vehicleNameController,
      fuelMileageController,
      fuelCostController;
  final List<VehicleDataWithId> vehicleDataWithIdList;
  final List<UserDataWithId> userDataWithIdList;
  final myFormKey;
  final SharedPreferences myPref;

  PlanFormViewThree(
      {@required this.fromLocationController,
      @required this.toLocationController,
      @required this.distanceController,
      @required this.dateController,
      @required this.noOfDaysController,
      @required this.vehicleNameController,
      @required this.fuelMileageController,
      @required this.fuelCostController,
      @required this.vehicleDataWithIdList,
      @required this.userDataWithIdList,
      @required this.myFormKey,
      @required this.myPref});

  @override
  _PlanFormViewThreeState createState() => _PlanFormViewThreeState();
}

class _PlanFormViewThreeState extends State<PlanFormViewThree> {
  DatabaseHelper _dbHelper;
  String _value, _selectedVehicle;

  List<DropdownMenuItem> _dropDownMenuItems() {
    List<DropdownMenuItem> dropdowmMenuItems = [];
    for (int i = 0; i < widget.vehicleDataWithIdList.length; i++) {
      dropdowmMenuItems.add(
        DropdownMenuItem(
          value: widget.vehicleDataWithIdList[i].vehicleName,
          child: Text(
            widget.vehicleDataWithIdList[i].vehicleName,
            style:
                TextStyle(color: Theme.of(context).textTheme.headline2.color),
          ),
        ),
      );
    }
    return dropdowmMenuItems;
  }

  // Automatically set the vehicle mileage from myVehicleData, a VehicleData
  // object which was passed to this view.
  // myVehicleData contains the vehicleData provided on completion of InitialSetup.
  // It may also contain additional VehicleData of other vehicles owned by the user
  // added to the database by the user after completion of InitialSetup.
  void _setVehicleMileage(String value) {
    for (int i = 0; i < widget.vehicleDataWithIdList.length; i++) {
      if (widget.vehicleDataWithIdList[i].vehicleName == value) {
        widget.fuelMileageController.text =
            widget.vehicleDataWithIdList[i].vehicleMileage.toString();
      }
    }
  }

  // Automatically set the fuel price from myUserData, a UserData object which was
  // passed to this view.
  // myUserData contains the UserData provided on completion of InitialSetup.
  void _setFuelPricePerLitre() {
    widget.fuelCostController.text =
        widget.userDataWithIdList[0].fuelPricePerLitre.toString();
  }

  // On Cancel button press display AlertDialog asking whether to cancel adn go back.
  // This is to prevent accidental press of Cancel button
  void _displayCancelAlert(double deviceWidth, double deviceHeight) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Are you sure?",
              style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
              ),
            ),
            content: Text(
              "All the data that you have entered so far will be lost.",
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Yes",
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
              ButtonTheme(
                child: OutlineButton(
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "No",
                    style: GoogleFonts.montserrat(
                      fontSize: 0.04 * deviceWidth,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                  textColor: Theme.of(context).textTheme.headline1.color,
                  onPressed: () {
                    // Go to homepage without doing anything
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  // SharedPreference operations: for SimpleAutoCompleteTextField suggestions
  List<String> _getFromList() {
    return widget.myPref.getStringList("fromList");
  }

  List<String> _getToList() {
    return widget.myPref.getStringList("toList");
  }

  Future<bool> _setFromList(List<String> myList) async {
    return await widget.myPref.setStringList("fromList", myList);
  }

  Future<bool> _setToList(List<String> myList) async {
    return await widget.myPref.setStringList("toList", myList);
  }

  // Save data to database
  NewPlanData _prepareDataForInsertion() {
    double totalDistance = double.parse(
        (double.parse(widget.distanceController.text)).toStringAsFixed(2));
    double fuelRequired = double.parse(
        (totalDistance / double.parse(widget.fuelMileageController.text))
            .toStringAsFixed(2));
    double rideFuelExpense = double.parse(
        (fuelRequired * widget.userDataWithIdList[0].fuelPricePerLitre)
            .toStringAsFixed(2));
    int totalnoOfMealsPerDay =
        (double.parse(widget.distanceController.text) < 200)
            ? 1
            : (widget.userDataWithIdList[0].noOfMealsPerDay);
    double rideFoodExpense = double.parse(
        ((int.parse(widget.noOfDaysController.text) * totalnoOfMealsPerDay) *
                (widget.userDataWithIdList[0].avgPriceOfOneMeal))
            .toStringAsFixed(2));
    double rideHotelExpense = double.parse(
        (widget.userDataWithIdList[0].avgPriceOfOneNightAtHotel *
                (int.parse(widget.noOfDaysController.text) - 1))
            .toStringAsFixed(2));
    double totalRideExpense = double.parse(
        (rideFoodExpense + rideFuelExpense + rideHotelExpense)
            .toStringAsFixed(2));
    return NewPlanData(
      source: widget.fromLocationController.text.trim(),
      destination: widget.toLocationController.text.trim(),
      beginDate: widget.dateController.text,
      totalDistance: totalDistance,
      totalNoOfDays: int.parse(widget.noOfDaysController.text),
      totalRideHotelExpense: rideHotelExpense,
      totalNoOfMealsPerDay: totalnoOfMealsPerDay,
      totalRideFoodExpense: rideFoodExpense,
      vehicleName: _selectedVehicle.trim(),
      vehicleMileage: double.parse(widget.fuelMileageController.text),
      totalRideFuelRequired: fuelRequired,
      totalRideFuelCost: rideFuelExpense,
      totalRideExpense: totalRideExpense,
    );
  }

  void _insertDataIntoDatabase() async {
    // insertNewPlanData() requires a NewPlanData object as parameter
    // _prepareDataForInsertion() will return a NewPlanData object
    NewPlanData newPlanData = _prepareDataForInsertion();
    _dbHelper.insertNewPlanData(newPlanData).then((value) => {
          _dbHelper.getUserData().then((userDataList) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    myUserDataWithId: userDataList[0],
                  ),
                ),
              )),
        });
    Navigator.pop(context);
  }

  void _submitData() {
    // SharedPreferences stuff
    // Set from and to locations ins SharedPreferences list for suggestions
    List<String> fromList = _getFromList();
    fromList.add(widget.fromLocationController.text);
    List<String> toList = _getToList();
    toList.add(widget.toLocationController.text);
    toList = toList.toSet().toList();
    fromList = fromList.toSet().toList();
    _setFromList(fromList);
    _setToList(toList);

    // Sqlite DB stuff
    _insertDataIntoDatabase();
  }

  @override
  void initState() {
    super.initState();
    _setFuelPricePerLitre();
    // Initialize DatabaseHelper before page load
    _dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.fromLTRB(0.04 * deviceWidth, 0.2 * deviceWidth,
          0.04 * deviceWidth, 0.01 * deviceWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 0.02 * deviceHeight,
          ),
          DropdownButton(
            items: _dropDownMenuItems(),
            onChanged: (value) {
              setState(() {
                _value = value;
                _selectedVehicle = value;
                _setVehicleMileage(value);
              });
            },
            hint: Text("Select your vehicle"),
            value: _value,
            isExpanded: true,
          ),
          SizedBox(
            height: 0.05 * deviceHeight,
          ),
          TextFormField(
            controller: widget.fuelMileageController,
            decoration: InputDecoration(
              hintText: "Vehicle mileage",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r"^\d+(\.\d*)?")),
            ],
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Please enter the vehicle mileage";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            autocorrect: true,
            autofocus: false,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
          ),
          SizedBox(
            height: 0.05 * deviceHeight,
          ),
          TextFormField(
            controller: widget.fuelCostController,
            decoration: InputDecoration(
              hintText: "Fuel cost per litre",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r"^\d+(\.\d*)?")),
            ],
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Please enter the cost of fuel per litre";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            autocorrect: true,
            autofocus: false,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
          ),
          SizedBox(
            height: 0.09 * deviceHeight,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: SizedBox(
                    height: 0.075 * deviceHeight,
                    width: 0.35 * deviceWidth,
                    child: FlatButton(
                      color: Theme.of(context).textTheme.headline1.color,
                      textColor: Colors.white,
                      splashColor: Theme.of(context)
                          .textTheme
                          .headline1
                          .color
                          .withAlpha(50),
                      onPressed: () {
                        if (widget.myFormKey.currentState.validate()) {
                          _submitData();
                        }
                      },
                      child: Text(
                        "Create",
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
                ),
                SizedBox(
                  width: 0.01 * deviceWidth,
                ),
                Flexible(
                  child: SizedBox(
                    height: 0.07 * deviceHeight,
                    width: 0.35 * deviceWidth,
                    child: OutlineButton(
                      textTheme: ButtonTextTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.montserrat(
                          fontSize: 0.04 * deviceWidth,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.headline1.color,
                      ),
                      textColor: Theme.of(context).textTheme.headline1.color,
                      onPressed: () {
                        _displayCancelAlert(deviceWidth, deviceHeight);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
