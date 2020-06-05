import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/data_models/vehicle_data.dart';
import 'package:xpedition/homepage/homepage.dart';
import 'package:xpedition/data_models/user_data.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/initial_setup_page/widgets/processing_page.dart';

class InitialSetupPage extends StatefulWidget {
  @override
  _InitialSetupPageState createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  String firstName;
  String lastName;
  String vehicleName;
  int maxKmInOneDay;
  double vehicleMileage;
  double fuelPricePerLitre;
  double avgPriceOfOneMeal;
  double avgPriceOfOneNightAtHotel;
  int noOfMealsPerDay;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _maxKmInOneDayController = TextEditingController();
  TextEditingController _vehicleMileageController = TextEditingController();
  TextEditingController _fuelPricePerLitreController = TextEditingController();
  TextEditingController _avgPriceOfOneMealController = TextEditingController();
  TextEditingController _avgPriceOfOneNightAtHotelController =
      TextEditingController();
  TextEditingController _noOfMealsPerDayController = TextEditingController();
  DatabaseHelper dbHelper;
  bool processing;
  SharedPreferences myPref;

  final _formKey = GlobalKey<FormState>();

  void _insertDataIntoDatabase() async {
    setState(() {
      processing = true;
    });

    // first create the table  and vehicle_data tables
    await dbHelper.createUserDataTable();
    await dbHelper.createVehicleDataTable();

    // Create a UserData obj and add it to the user_data table.
    final userData = UserData(
        firstName: firstName,
        lastName: lastName,
        maxKmInOneDay: maxKmInOneDay,
        fuelPricePerLitre: fuelPricePerLitre,
        avgPriceOfOneMeal: avgPriceOfOneMeal,
        avgPriceOfOneNightAtHotel: avgPriceOfOneNightAtHotel,
        noOfMealsPerDay: noOfMealsPerDay);

    await dbHelper.insertUserData(userData);

    // Create a UserData obj and add it to the user_data table.
    final vehicleData =
        VehicleData(vehicleName: vehicleName, vehicleMileage: vehicleMileage);

    await dbHelper.insertVehicleData(vehicleData);
  }

  Future<void> _createFromToSuggestionList() async {
    List<String> fromList = [];
    List<String> toList = [];
    await myPref.setStringList("fromList", fromList);
    await myPref.setStringList("toList", toList);
  }

  void _submitData() {
    _createFromToSuggestionList();

    this.firstName = _firstNameController.text;
    this.lastName = _lastNameController.text;
    this.vehicleName = _vehicleNameController.text;
    this.maxKmInOneDay = int.parse(_maxKmInOneDayController.text);
    this.vehicleMileage = double.parse(_vehicleMileageController.text);
    this.fuelPricePerLitre = double.parse(_fuelPricePerLitreController.text);
    this.avgPriceOfOneMeal = double.parse(_avgPriceOfOneMealController.text);
    this.avgPriceOfOneNightAtHotel =
        double.parse(_avgPriceOfOneNightAtHotelController.text);
    this.noOfMealsPerDay = int.parse(_noOfMealsPerDayController.text);

    _insertDataIntoDatabase();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void initSharedPref() async {
    myPref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    processing = false;
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: processing
            ? ProcessingPage()
            : Container(
                padding: EdgeInsets.fromLTRB(0.04 * deviceWidth,
                    0.07 * deviceWidth, 0.04 * deviceWidth, 0.05 * deviceWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Initial Setup",
                          style: GoogleFonts.montserrat(
                            fontSize: 0.06 * deviceWidth,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.02 * deviceHeight,
                      ),
                      Text(
                        "Please provide following data",
                        style: GoogleFonts.montserrat(
                          fontSize: 0.05 * deviceWidth,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                      ),
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
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                        controller: _vehicleNameController,
                        decoration: InputDecoration(
                          hintText: "Vehicle name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                      SizedBox(
                        height: 0.015 * deviceHeight,
                      ),
                      TextFormField(
                        controller: _maxKmInOneDayController,
                        decoration: InputDecoration(
                          hintText: "Max KM you can travel in a day",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _vehicleMileageController,
                              decoration: InputDecoration(
                                hintText: "Vehicle mileage",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                              controller: _fuelPricePerLitreController,
                              decoration: InputDecoration(
                                hintText: "Fuel price/litre",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _avgPriceOfOneMealController,
                              decoration: InputDecoration(
                                hintText: "Avg. price of a meal",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                        height: 0.06 * deviceHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: SizedBox(
                              height: 0.075 * deviceHeight,
                              width: 0.35 * deviceWidth,
                              child: FlatButton(
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                textColor: Colors.white,
                                splashColor: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .color
                                    .withAlpha(50),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _submitData();
                                  }
                                  myPref.setBool("complete_init_setup", true);
                                },
                                child: Text(
                                  "Submit",
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
                                  "Do it later",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 0.04 * deviceWidth,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                                textColor:
                                    Theme.of(context).textTheme.headline1.color,
                                onPressed: () {
                                  // Go to homepage without doing anything
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
