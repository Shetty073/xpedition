import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/vehicle_data.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';

class UpdateInitialSettingsPage extends StatefulWidget {
  final UserDataWithId userDataWithId;
  final VoidCallback callBackFunction;
  final List<VehicleDataWithId> vehicleDataWithIdList;

  UpdateInitialSettingsPage(
      {@required this.userDataWithId,
      @required this.callBackFunction,
      @required this.vehicleDataWithIdList});

  @override
  _UpdateInitialSettingsPageState createState() =>
      _UpdateInitialSettingsPageState();
}

class _UpdateInitialSettingsPageState extends State<UpdateInitialSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _maxKmInOneDayController = TextEditingController();
  TextEditingController _fuelPricePerLitreController = TextEditingController();
  TextEditingController _avgPriceOfOneMealController = TextEditingController();
  TextEditingController _avgPriceOfOneNightAtHotelController =
      TextEditingController();
  TextEditingController _noOfMealsPerDayController = TextEditingController();

  TextEditingController _vehicleNameControllerOne = TextEditingController();
  TextEditingController _vehicleMileageControllerOne = TextEditingController();
  TextEditingController _vehicleNameControllerTwo = TextEditingController();
  TextEditingController _vehicleMileageControllerTwo = TextEditingController();
  TextEditingController _vehicleNameControllerThree = TextEditingController();
  TextEditingController _vehicleMileageControllerThree =
      TextEditingController();
  TextEditingController _vehicleNameControllerFour = TextEditingController();
  TextEditingController _vehicleMileageControllerFour = TextEditingController();
  TextEditingController _vehicleNameControllerFive = TextEditingController();
  TextEditingController _vehicleMileageControllerFive = TextEditingController();

  bool _toggleEdit = false;
  DatabaseHelper _myDbHelper;
  List<TextEditingController> _vehicleNameControllerList;
  List<TextEditingController> _vehicleMileageControllerList;

  void _setOldData() {
    _vehicleNameControllerList = [
      _vehicleNameControllerOne,
      _vehicleNameControllerTwo,
      _vehicleNameControllerThree,
      _vehicleNameControllerFour,
      _vehicleNameControllerFive,
    ];
    _vehicleMileageControllerList = [
      _vehicleMileageControllerOne,
      _vehicleMileageControllerTwo,
      _vehicleMileageControllerThree,
      _vehicleMileageControllerFour,
      _vehicleMileageControllerFive,
    ];

    _firstNameController.text = widget.userDataWithId.firstName;
    _lastNameController.text = widget.userDataWithId.lastName;
    _maxKmInOneDayController.text =
        widget.userDataWithId.maxKmInOneDay.toString();
    _fuelPricePerLitreController.text =
        widget.userDataWithId.fuelPricePerLitre.toStringAsFixed(2);
    _avgPriceOfOneMealController.text =
        widget.userDataWithId.avgPriceOfOneMeal.toStringAsFixed(2);
    _avgPriceOfOneNightAtHotelController.text =
        widget.userDataWithId.avgPriceOfOneNightAtHotel.toStringAsFixed(2);
    _noOfMealsPerDayController.text =
        widget.userDataWithId.noOfMealsPerDay.toString();

    for (int i = 0; i < widget.vehicleDataWithIdList.length; i++) {
      _vehicleNameControllerList[i].text =
          widget.vehicleDataWithIdList[i].vehicleName;
      _vehicleMileageControllerList[i].text =
          widget.vehicleDataWithIdList[i].vehicleMileage.toStringAsFixed(2);
    }
  }

  UserDataWithId _prepareUserDataForInsertion() {
    return UserDataWithId(
      id: widget.userDataWithId.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      maxKmInOneDay: int.parse(_maxKmInOneDayController.text.trim()),
      fuelPricePerLitre: double.parse(_fuelPricePerLitreController.text.trim()),
      avgPriceOfOneMeal: double.parse(_avgPriceOfOneMealController.text.trim()),
      avgPriceOfOneNightAtHotel:
          double.parse(_avgPriceOfOneNightAtHotelController.text.trim()),
      noOfMealsPerDay: int.parse(_noOfMealsPerDayController.text.trim()),
    );
  }

  List<VehicleData> _prepareVehicleDataForInsertion() {
    widget.vehicleDataWithIdList.forEach((vehicleData) {
      _myDbHelper.deleteVehicleData(vehicleData);
    });

    List<VehicleData> newVehicleDataList = [];

    for (int i = 0; i < 5; i++) {
      if (_vehicleMileageControllerList[i].text.trim() != "" &&
          _vehicleMileageControllerList[i].text.trim() != "") {
        newVehicleDataList.add(
          VehicleData(
            vehicleName: _vehicleNameControllerList[i].text.trim(),
            vehicleMileage: double.parse(_vehicleMileageControllerList[i].text),
          ),
        );
      }
    }
    return newVehicleDataList;
  }

  void _saveEveryThing() async {
    UserDataWithId newPlanDataWithId = _prepareUserDataForInsertion();
    _myDbHelper.updateUserData(newPlanDataWithId);

    List<VehicleData> newVehicleDataList = _prepareVehicleDataForInsertion();
    newVehicleDataList.forEach((vehicleData) {
      _myDbHelper.insertVehicleData(vehicleData);
    });

    widget.callBackFunction();
  }

  void _displaySaveAlert(double deviceWidth, double deviceHeight) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Do you want to save the changes?",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          content: Text(
            "Do you want to save the edits you made to this plan? If you select No"
            " then all changes will be lost. This action cannot be undone.",
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
                  _saveEveryThing();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
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
                  "Don't save",
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _myDbHelper = DatabaseHelper();
    _setOldData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    _toggleEdit
                        ? _displaySaveAlert(deviceWidth, deviceHeight)
                        : Navigator.pop(context);
                  }
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
                  "Manage user data",
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
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _toggleEdit = !_toggleEdit;
                });

                if (_formKey.currentState.validate()) {
                  if (_toggleEdit == false) {
                    // save changes
                    _saveEveryThing();
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 0.004 * deviceWidth,
                  ),
                ),
                padding: EdgeInsets.only(
                    right: 0.015 * deviceWidth,
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.015 * deviceWidth),
                margin: EdgeInsets.only(
                    right: 0.015 * deviceWidth,
                    top: 0.03 * deviceWidth,
                    bottom: 0.03 * deviceWidth),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).primaryColor,
                        size: 0.045 * deviceWidth,
                      ),
                      child: Icon(
                        _toggleEdit ? Icons.save : Icons.edit,
                      ),
                    ),
                    SizedBox(
                      width: 0.005 * deviceWidth,
                    ),
                    Text(
                      _toggleEdit ? "Save" : "Edit",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 0.04 * deviceWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(
                left: 0.025 * deviceWidth, right: 0.025 * deviceWidth),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 0.02 * deviceHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "First name:",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 0.035 * deviceWidth,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  enabled: _toggleEdit,
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    hintText: "First name",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "Please enter your first name";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  autofocus: false,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0.03 * deviceWidth,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Last name:",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 0.035 * deviceWidth,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  enabled: _toggleEdit,
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    hintText: "Last name",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "Please enter your last name";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  autofocus: false,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.03 * deviceHeight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Max KM you can travel in a day:",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                fontSize: 0.035 * deviceWidth,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _toggleEdit,
                            controller: _maxKmInOneDayController,
                            decoration: InputDecoration(
                              hintText: "Max KM you can travel in a day",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r"^[0-9]+$")),
                            ],
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "This field cannot be empty";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                            autofocus: false,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.03 * deviceHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Avg. price of a meal:",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 0.035 * deviceWidth,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  enabled: _toggleEdit,
                                  controller: _avgPriceOfOneMealController,
                                  decoration: InputDecoration(
                                    hintText: "Avg. price of a meal",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^\d+(\.\d*)?")),
                                  ],
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "This field cannot be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  autocorrect: true,
                                  autofocus: false,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0.03 * deviceWidth,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Price of hotel/night:",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 0.035 * deviceWidth,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  enabled: _toggleEdit,
                                  controller:
                                      _avgPriceOfOneNightAtHotelController,
                                  decoration: InputDecoration(
                                    hintText: "Price of hotel/night",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^\d+(\.\d*)?")),
                                  ],
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "This field cannot be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  autocorrect: true,
                                  autofocus: false,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.03 * deviceHeight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "No. of meals/day:",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                fontSize: 0.035 * deviceWidth,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _toggleEdit,
                            controller: _noOfMealsPerDayController,
                            decoration: InputDecoration(
                              hintText: "No. of meals/day",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r"^[0-9]+$")),
                            ],
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "This field cannot be empty";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                            autofocus: false,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.03 * deviceHeight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Fuel price/litre:",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                fontSize: 0.035 * deviceWidth,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _toggleEdit,
                            controller: _fuelPricePerLitreController,
                            decoration: InputDecoration(
                              hintText: "Fuel price/litre",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d+(\.\d*)?")),
                            ],
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "This field cannot be empty";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                            autofocus: false,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.05 * deviceHeight,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Vehicle management:",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 0.05 * deviceWidth,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.01 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleNameControllerOne,
                        decoration: InputDecoration(
                          hintText: "1st Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Please enter a valid vehicle name";
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
                    ),
                    SizedBox(
                      width: 0.015 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleMileageControllerOne,
                        decoration: InputDecoration(
                          hintText: "1st Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "This field cannot be empty";
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleNameControllerTwo,
                        decoration: InputDecoration(
                          hintText: "2nd Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Please enter a valid vehicle name";
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
                    ),
                    SizedBox(
                      width: 0.015 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleMileageControllerTwo,
                        decoration: InputDecoration(
                          hintText: "2nd Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "This field cannot be empty";
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleNameControllerThree,
                        decoration: InputDecoration(
                          hintText: "3rd Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Please enter a valid vehicle name";
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
                    ),
                    SizedBox(
                      width: 0.015 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleMileageControllerThree,
                        decoration: InputDecoration(
                          hintText: "3rd Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "This field cannot be empty";
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleNameControllerFour,
                        decoration: InputDecoration(
                          hintText: "4th Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Please enter a valid vehicle name";
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
                    ),
                    SizedBox(
                      width: 0.015 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleMileageControllerFour,
                        decoration: InputDecoration(
                          hintText: "4th Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "This field cannot be empty";
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleNameControllerFive,
                        decoration: InputDecoration(
                          hintText: "5th Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Please enter a valid vehicle name";
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
                    ),
                    SizedBox(
                      width: 0.015 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: _toggleEdit,
                        controller: _vehicleMileageControllerFive,
                        decoration: InputDecoration(
                          hintText: "5th Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "This field cannot be empty";
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03 * deviceHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
