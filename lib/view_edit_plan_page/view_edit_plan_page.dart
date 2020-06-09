import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/view_edit_plan_page/widgets/key_value_row.dart';

class ViewEditPlanPage extends StatefulWidget {
  final NewPlanDataWithId newPlanDataWithId;
  final UserDataWithId userDataWithId;
  final List<VehicleDataWithId> vehicleDataWithIdList;

  ViewEditPlanPage({@required this.newPlanDataWithId, @required this.userDataWithId, @required this.vehicleDataWithIdList});

  @override
  _ViewEditPlanPageState createState() => _ViewEditPlanPageState();
}

class _ViewEditPlanPageState extends State<ViewEditPlanPage> {
  DatabaseHelper _myDbHelper = DatabaseHelper();
  static final _formKey = GlobalKey<FormState>();
  TextEditingController _fromEditingController = TextEditingController();
  TextEditingController _toEditingController = TextEditingController();
  TextEditingController _dateEditingController = TextEditingController();
  TextEditingController _distanceEditingController = TextEditingController();
  TextEditingController _timeEditingController = TextEditingController();
  TextEditingController _daysEditingController = TextEditingController();
  TextEditingController _mileageEditingController = TextEditingController();
  TextEditingController _totalFuelRequiredEditingController =
      TextEditingController();
  TextEditingController _fuelPerUnitCostEditingController =
      TextEditingController();
  TextEditingController _totalFuelExpenseEditingController =
      TextEditingController();
  TextEditingController _singleMealExpenseEditingController =
      TextEditingController();
  TextEditingController _noOfMealsEditingController = TextEditingController();
  TextEditingController _totalFoodExpenseEditingController =
      TextEditingController();
  TextEditingController _hotelCostEditingController = TextEditingController();
  TextEditingController _totalHotelExpenseEditingController =
      TextEditingController();
  bool _toggleEdit = false;

  String _value;

  // When we use google maps offline, google uses the following formula to
  // get ETA from source to destination: (totalDistance / 40) where 40 is the
  // average speed of the vehicle
  int getHours(double distance) {
    List<String> res = (distance / 40).toString().split(".");
    return int.parse(res[0]);
  }

  int getMins(double distance) {
    List<String> res = (distance / 40).toString().split(".");
    if (res[1].length > 2) {
      return int.parse(res[1].substring(0, 2));
    }
    return int.parse(res[1]);
  }

  void _initialTextFill() {
    // NOTE: This is where the values from db are filled initially
    // Location card
    _fromEditingController.text = widget.newPlanDataWithId.source;
    _toEditingController.text = widget.newPlanDataWithId.destination;
    _dateEditingController.text = widget.newPlanDataWithId.beginDate;
    _distanceEditingController.text =
        widget.newPlanDataWithId.totalDistance.toString();
    _timeEditingController.text =
        "${getHours(widget.newPlanDataWithId.totalDistance)} hrs ${getMins(widget.newPlanDataWithId.totalDistance)} mins";
    _daysEditingController.text =
        "${widget.newPlanDataWithId.totalNoOfDays} ${widget.newPlanDataWithId.totalNoOfDays > 1 ? "days" : "day"}";
    _distanceEditingController.addListener(() {
      _updateTripTime(double.parse(_distanceEditingController.text));
      _updateTripDays(double.parse(_distanceEditingController.text));
    });

    // Fuel card
    _value = widget.newPlanDataWithId.vehicleName;
    _mileageEditingController.text = widget.newPlanDataWithId.vehicleMileage.toString();
    _fuelPerUnitCostEditingController.text = widget.userDataWithId.fuelPricePerLitre.toString();
    _totalFuelRequiredEditingController.text = widget.newPlanDataWithId.totalRideFuelRequired.toString();
    _totalFuelExpenseEditingController.text = widget.newPlanDataWithId.totalRideFuelCost.toString();
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2020),
      lastDate: new DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFF8200),
            accentColor: const Color(0xFFECA72C),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFF8200),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateEditingController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

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

  void _updateTripTime(double newDistanceValue) {
    int hrs = getHours(newDistanceValue);
    int mins = getMins(newDistanceValue);
    setState(() {
      _timeEditingController.text = "$hrs hrs $mins mins";
    });
  }

  void _updateTripDays(double newDistanceValue) async {
    List<UserDataWithId> _myUserDataWithId = await _myDbHelper.getUserData();
    int maxKmInOneDay = _myUserDataWithId[0].maxKmInOneDay;
    double tNoDays = (newDistanceValue / maxKmInOneDay);
    String totalTripDays = tNoDays.toString();
    List<String> decSplit;
    decSplit = totalTripDays.split(".");
    int preDec, postDec, totalDays;
    preDec = int.parse(decSplit[0]);
    postDec = int.parse(decSplit[1]);
    String unit = "day";
    if(postDec != 0) {
      totalDays = preDec + 1;
    } else {
      totalDays = preDec;
    }
    if(totalDays > 1) {
      unit = "days";
    }
    setState(() {
      _daysEditingController.text = "${totalDays.toString()} $unit";
    });
  }

  void _setVehicleMileage(String value) async {
    List<VehicleDataWithId> _vehicleData = await _myDbHelper.getVehicleData();
    for (int i = 0; i < _vehicleData.length; i++) {
      if (_vehicleData[i].vehicleName == value) {
        _mileageEditingController.text =
            _vehicleData[i].vehicleMileage.toString();
      }
    }
  }

  void _setFuelRequired() {
    
  }

  void _setTotalFuelCost() {

  }

  void _saveEverythingAndGoBack() {
    // TODO: Implement _saveEverythingAndGoBack()
  }

  @override
  void initState() {
    super.initState();
    _initialTextFill();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // _saveEverythingAndGoBack();
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
                "${widget.newPlanDataWithId.source} to ${widget.newPlanDataWithId.destination}",
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
          GestureDetector(
            onTap: () {
              // TODO: showDeleteAlert

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
                  Text(
                    "Delete",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 0.04 * deviceWidth,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.005 * deviceWidth,
                  ),
                  IconTheme(
                    data: IconThemeData(
                      color: Theme.of(context).primaryColor,
                      size: 0.045 * deviceWidth,
                    ),
                    child: Icon(
                      Icons.delete,
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
        padding: EdgeInsets.all(0.0),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: 0.27 * deviceHeight,
                width: 0.92 * deviceWidth,
                padding: EdgeInsets.only(
                    left: 0.04 * deviceWidth,
                    right: 0.025 * deviceWidth,
                    top: 0.001 * deviceWidth,
                    bottom: 0.02 * deviceWidth),
                margin: EdgeInsets.only(
                    left: 0.04 * deviceWidth,
                    right: 0.03 * deviceWidth,
                    top: 0.025 * deviceWidth,
                    bottom: 0.025 * deviceWidth),
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline4.color,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).textTheme.headline5.color,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(
                      left: 0.00,
                      top: 0.025 * deviceWidth,
                      right: 0.01 * deviceWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _fromEditingController,
                        keyText: "From",
                        errorText: "The source location name cannot be empty",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.text,
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _toEditingController,
                        keyText: "To",
                        errorText: "The destination name cannot be empty",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.text,
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _dateEditingController,
                        keyText: "Begin date",
                        errorText: "Please enter the trip begin date",
                        onTapCallbackNeeded: true,
                        onTapCallbackFunction: _selectDate,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.datetime,
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _distanceEditingController,
                        keyText: "Total distance (Km)",
                        errorText: "Please enter the total distance",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: true,
                        onChangeCallbackFunction: (distanceValue) {
                          _updateTripTime(distanceValue);
                        },
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _timeEditingController,
                        keyText: "Estd. trip time",
                        errorText: "Trip time is automatically calculated",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _daysEditingController,
                        keyText: "Estd. days",
                        errorText: "Trip duration in days is automatically calculated",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.255 * deviceHeight,
                width: 0.92 * deviceWidth,
                padding: EdgeInsets.only(
                    left: 0.04 * deviceWidth,
                    right: 0.025 * deviceWidth,
                    top: 0.001 * deviceWidth,
                    bottom: 0.02 * deviceWidth),
                margin: EdgeInsets.only(
                    left: 0.04 * deviceWidth,
                    right: 0.03 * deviceWidth,
                    top: 0.025 * deviceWidth,
                    bottom: 0.025 * deviceWidth),
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline4.color,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).textTheme.headline5.color,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(
                      left: 0.00,
                      top: 0.025 * deviceWidth,
                      right: 0.01 * deviceWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IgnorePointer(
                        child: DropdownButton(
                          items: _dropDownMenuItems(),
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                              _setVehicleMileage(value);
                            });
                          },
                          hint: Text("Select your vehicle"),
                          value: _value,
                          isExpanded: true,
                          elevation: 0,
                          style: GoogleFonts.montserrat(),
                        ),
                        ignoring: !_toggleEdit,
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _mileageEditingController,
                        keyText: "Mileage",
                        errorText: "Please enter proper mileage value",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _fuelPerUnitCostEditingController,
                        keyText: "Fuel cost (per unit)",
                        errorText: "Please enter proper fuel cost/unit",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _totalFuelRequiredEditingController,
                        keyText: "Total fuel required",
                        errorText: "Please enter the total amount of fuel required",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.datetime,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _totalFuelExpenseEditingController,
                        keyText: "Total fuel cost",
                        errorText: "Please enter the total fuel cost",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        onChangeCallbackFunction: (distanceValue) {
                          _updateTripTime(distanceValue);
                        },
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                    ],
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
