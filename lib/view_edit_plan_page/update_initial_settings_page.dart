import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';

class UpdateInitialSettingsPage extends StatefulWidget {
  final VoidCallback callBackFunction;

  UpdateInitialSettingsPage({@required this.callBackFunction});

  @override
  _UpdateInitialSettingsPageState createState() => _UpdateInitialSettingsPageState();
}

class _UpdateInitialSettingsPageState extends State<UpdateInitialSettingsPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _maxKmInOneDayController = TextEditingController();
  TextEditingController _vehicleMileageController = TextEditingController();
  TextEditingController _fuelPricePerLitreController = TextEditingController();
  TextEditingController _avgPriceOfOneMealController = TextEditingController();
  TextEditingController _avgPriceOfOneNightAtHotelController = TextEditingController();
  TextEditingController _noOfMealsPerDayController = TextEditingController();

  bool _toggleEdit = false;
  DatabaseHelper _myDbHelper;

  UserDataWithId _prepareDataForInsertion() {

  }

  void _saveEveryThing() async {
    UserDataWithId newPlanDataWithId = _prepareDataForInsertion();
    //_myDbHelper.updateNewPlanData(newPlanDataWithId);
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
                  _toggleEdit
                      ? _displaySaveAlert(deviceWidth, deviceHeight)
                      : Navigator.pop(context);
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
                  "User data",
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
                if (_toggleEdit == false) {
                  // save changes
                  _saveEveryThing();
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
            padding: EdgeInsets.only(left: 0.025 * deviceWidth, right: 0.025 * deviceWidth),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 0.02 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: "First name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
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
                    ),
                    SizedBox(
                      width: 0.03 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: "Last name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.015 * deviceHeight,
                ),
                TextFormField(
                  controller: _maxKmInOneDayController,
                  decoration: InputDecoration(
                    hintText: "Max KM you can travel in a day",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
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
                SizedBox(
                  height: 0.015 * deviceHeight,
                ),
                TextFormField(
                  controller: _fuelPricePerLitreController,
                  decoration: InputDecoration(
                    hintText: "Fuel price/litre",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(
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
                SizedBox(
                  height: 0.015 * deviceHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: _avgPriceOfOneMealController,
                        decoration: InputDecoration(
                          hintText: "Avg. price of a meal",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
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
                    ),
                    SizedBox(
                      width: 0.03 * deviceWidth,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _avgPriceOfOneNightAtHotelController,
                        decoration: InputDecoration(
                          hintText: "Price of hotel/night",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.015 * deviceHeight,
                ),
                TextFormField(
                  controller: _noOfMealsPerDayController,
                  decoration: InputDecoration(
                    hintText: "No. of meals/day",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
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
                SizedBox(
                  height: 0.04 * deviceHeight,
                ),
                // TODO: Add multiple vehicles
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
                        controller: _vehicleNameController,
                        decoration: InputDecoration(
                          hintText: "Vehicle name",
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
                        controller: _vehicleMileageController,
                        decoration: InputDecoration(
                          hintText: "Vehicle mileage",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
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

