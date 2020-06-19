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
  final bool isPlanActive, alreadyHasAnActivePlan, isPlanComplete;
  final VoidCallback callBackFunction;

  ViewEditPlanPage({
    @required this.newPlanDataWithId,
    @required this.userDataWithId,
    @required this.vehicleDataWithIdList,
    @required this.isPlanActive,
    @required this.alreadyHasAnActivePlan,
    @required this.isPlanComplete,
    @required this.callBackFunction,
  });

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
  TextEditingController _totalRideExpenseController = TextEditingController();
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
        widget.newPlanDataWithId.totalDistance.toStringAsFixed(2);
    _timeEditingController.text =
        "${getHours(widget.newPlanDataWithId.totalDistance)} hrs ${getMins(widget.newPlanDataWithId.totalDistance)} mins";
    _daysEditingController.text =
        widget.newPlanDataWithId.totalNoOfDays.toString();
    _distanceEditingController.addListener(() {
      _updateTripTime();
      _updateTripDays();
    });
    _daysEditingController.addListener(() {
      _updateTotalHotelExpense();
    });

    // Fuel card
    _value = widget.newPlanDataWithId.vehicleName;
    _mileageEditingController.text =
        widget.newPlanDataWithId.vehicleMileage.toStringAsFixed(2);
    _fuelPerUnitCostEditingController.text =
        widget.userDataWithId.fuelPricePerLitre.toStringAsFixed(2);
    _totalFuelRequiredEditingController.text =
        widget.newPlanDataWithId.totalRideFuelRequired.toStringAsFixed(2);
    _totalFuelExpenseEditingController.text =
        widget.newPlanDataWithId.totalRideFuelCost.toStringAsFixed(2);
    _fuelPerUnitCostEditingController.addListener(() {
      _updateFuelData();
      _updateTotalRideExpense();
    });

    // Meal card
    _singleMealExpenseEditingController.text =
        widget.userDataWithId.avgPriceOfOneMeal.toStringAsFixed(2);
    _noOfMealsEditingController.text =
        widget.newPlanDataWithId.totalNoOfMealsPerDay.toString();
    _totalFoodExpenseEditingController.text =
        widget.newPlanDataWithId.totalRideFoodExpense.toString();
    _singleMealExpenseEditingController.addListener(() {
      _updateTotalFoodExpense();
      _updateTotalRideExpense();
    });
    _noOfMealsEditingController.addListener(() {
      _updateTotalFoodExpense();
      _updateTotalRideExpense();
    });

    // Hotel card
    _hotelCostEditingController.text =
        widget.userDataWithId.avgPriceOfOneNightAtHotel.toStringAsFixed(2);
    _totalHotelExpenseEditingController.text =
        widget.newPlanDataWithId.totalRideHotelExpense.toStringAsFixed(2);
    _hotelCostEditingController.addListener(() {
      _updateTotalHotelExpense();
      _updateTotalRideExpense();
    });

    // Total ride expense
    _totalRideExpenseController.text =
        widget.newPlanDataWithId.totalRideExpense.toString();
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

  void _updateTripTime() {
    if (_distanceEditingController.text != "") {
      int hrs = getHours(double.parse(_distanceEditingController.text));
      int mins = getMins(double.parse(_distanceEditingController.text));
      _timeEditingController.text = "$hrs hrs $mins mins";
    }
  }

  void _updateTripDays() async {
    List<UserDataWithId> _myUserDataWithId = await _myDbHelper.getUserData();
    int maxKmInOneDay = _myUserDataWithId[0].maxKmInOneDay;
    double tNoDays =
        (double.parse(_distanceEditingController.text) / maxKmInOneDay);
    String totalTripDays = tNoDays.toString();
    List<String> decSplit;
    decSplit = totalTripDays.split(".");
    int preDec, postDec, totalDays;
    preDec = int.parse(decSplit[0]);
    postDec = int.parse(decSplit[1]);
    if (postDec != 0) {
      totalDays = preDec + 1;
    } else {
      totalDays = preDec;
    }
    setState(() {
      _daysEditingController.text = totalDays.toString();
    });
  }

  void _updateVehicleMileage(String value) async {
    List<VehicleDataWithId> _vehicleData = await _myDbHelper.getVehicleData();
    for (int i = 0; i < _vehicleData.length; i++) {
      if (_vehicleData[i].vehicleName == value) {
        _mileageEditingController.text =
            _vehicleData[i].vehicleMileage.toString();
      }
    }
  }

  void _updateFuelData() {
    if (_fuelPerUnitCostEditingController.text != "") {
      _totalFuelExpenseEditingController.text =
          (double.parse(_fuelPerUnitCostEditingController.text) *
                  double.parse(_totalFuelRequiredEditingController.text))
              .toStringAsFixed(2);
    }
  }

  void _updateFuelDataOnVehicleChange() {
    if (_fuelPerUnitCostEditingController.text != "") {
      _totalFuelRequiredEditingController.text =
          (double.parse(_distanceEditingController.text) /
                  double.parse(_mileageEditingController.text))
              .toStringAsFixed(2);
      _totalFuelExpenseEditingController.text =
          (double.parse(_fuelPerUnitCostEditingController.text) *
                  double.parse(_totalFuelRequiredEditingController.text))
              .toStringAsFixed(2);
    }
  }

  void _updateTotalFoodExpense() {
    if (_daysEditingController.text != "" &&
        _noOfMealsEditingController.text != "" &&
        _singleMealExpenseEditingController.text != "") {
      _totalFoodExpenseEditingController.text =
          ((int.parse(_daysEditingController.text) *
                      int.parse(_noOfMealsEditingController.text)) *
                  double.parse(_singleMealExpenseEditingController.text))
              .toStringAsFixed(2);
    }
  }

  void _updateTotalHotelExpense() {
    if (_daysEditingController.text != "" &&
        _hotelCostEditingController.text != "") {
      _totalHotelExpenseEditingController.text =
          ((int.parse(_daysEditingController.text) - 1) *
                  double.parse(_hotelCostEditingController.text))
              .toStringAsFixed(2);
    }
  }

  void _updateTotalRideExpense() {
    if (_totalFoodExpenseEditingController.text != "" &&
        _totalFuelExpenseEditingController.text != "" &&
        _totalHotelExpenseEditingController.text != "") {
      _totalRideExpenseController.text =
          (double.parse(_totalFoodExpenseEditingController.text) +
                  double.parse(_totalFuelExpenseEditingController.text) +
                  double.parse(_totalHotelExpenseEditingController.text))
              .toStringAsFixed(2);
    }
  }

  NewPlanDataWithId _prepareDataForInsertion() {
    return NewPlanDataWithId(
      id: widget.newPlanDataWithId.id,
      source: _fromEditingController.text,
      destination: _toEditingController.text,
      beginDate: _dateEditingController.text,
      totalDistance: double.parse(_distanceEditingController.text),
      totalNoOfDays: int.parse(_daysEditingController.text),
      totalRideHotelExpense:
          double.parse(_totalHotelExpenseEditingController.text),
      totalNoOfMealsPerDay: int.parse(_noOfMealsEditingController.text),
      totalRideFoodExpense:
          double.parse(_totalFoodExpenseEditingController.text),
      vehicleName: _value,
      vehicleMileage: double.parse(_mileageEditingController.text),
      totalRideFuelRequired:
          double.parse(_totalFuelRequiredEditingController.text),
      totalRideFuelCost: double.parse(_totalFuelExpenseEditingController.text),
      totalRideExpense: double.parse(_totalRideExpenseController.text),
    );
  }

  void _activatePlan() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper.insertActivePlanData(newPlanDataWithId);
    _myDbHelper.deleteNewPlanData(newPlanDataWithId);
    Navigator.pop(context);
  }

  void _displayActivateAlert(double deviceWidth, double deviceHeight) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Do you want to mark this plan as active? This action cannot be undone!",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          content: Text(
            "Activating this plan will mark it as active i.e. you have started your trip. This unlocks some additional features"
            " such as adding notes about a place for future reference, adjusting price on the go and many other things. Once a plan is marked"
            " as active it cannot be unmarked but it can be marked as completed (your trip has be completed).",
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
                  _activatePlan();
                  Navigator.pop(context);
                },
                child: Text(
                  "Activate",
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
                  "Back",
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
      },
    );
  }

  void _displayAlreadyAnotherPlanActiveAlert(
      double deviceWidth, double deviceHeight) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Only one plan can be active at a time!",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          content: Text(
            "How man places can you be at once? Its a rhetorical question. In this app at a time only one plan can be marked as active and it seems like"
            " you have already marked one. In order to mark this one as active you must either complete the one you have marked as active or delete it.",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
          actions: <Widget>[
            ButtonTheme(
              child: OutlineButton(
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  "Back",
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
      },
    );
  }

  void _saveEveryThing() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper.updateNewPlanData(newPlanDataWithId);
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

  void _deleteThisPlan() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper.deleteNewPlanData(newPlanDataWithId).then((value) => {
          Navigator.pop(context),
          Navigator.pop(context),
        });
  }

  void _deleteThisActivePlan() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper
        .deleteActivePlanData(newPlanDataWithId)
        .then((value) => {Navigator.pop(context), Navigator.pop(context)});
  }

  void _deleteThisCompletedPlan() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper
        .deleteCompletedPlanData(newPlanDataWithId)
        .then((value) => {widget.callBackFunction()});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _displayDeleteAlert(double deviceWidth, double deviceHeight) {
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
            "Are you sure that you want to delete this plan. Delete action cannot be undone!",
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
                  // ignore: unnecessary_statements
                  (!widget.isPlanComplete)
                      ? ((widget.isPlanActive)
                          ? _deleteThisActivePlan()
                          : _deleteThisPlan())
                      : _deleteThisCompletedPlan();
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
      },
    );
  }

  void _completeThisPlan() async {
    NewPlanDataWithId newPlanDataWithId = _prepareDataForInsertion();
    _myDbHelper.insertCompletedPlanData(newPlanDataWithId);
    _myDbHelper.deleteActivePlanData(newPlanDataWithId);
  }

  void _displayCompleteAlert(double deviceWidth, double deviceHeight) {
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
            "Are you sure that you want to mark this plan as finished",
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
                  _completeThisPlan();
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
      },
    );
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
          (!widget.isPlanActive)
              ? GestureDetector(
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
                )
              : Container(),
          GestureDetector(
            onTap: () {
              _displayDeleteAlert(deviceWidth, deviceHeight);
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
                          _updateTripTime();
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
                        keyText: "Trip time @40Km/h",
                        errorText: "Trip time is automatically calculated",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _daysEditingController,
                        keyText:
                            "No. of days @${widget.userDataWithId.maxKmInOneDay}KM/day",
                        errorText:
                            "Trip duration in days is automatically calculated",
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
                      _toggleEdit
                          ? DropdownButton(
                              items: _dropDownMenuItems(),
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                  _updateVehicleMileage(value);
                                  _updateFuelDataOnVehicleChange();
                                });
                              },
                              hint: Text("Select your vehicle"),
                              value: _value,
                              isExpanded: true,
                              elevation: 0,
                              style: GoogleFonts.montserrat(),
                            )
                          : IgnorePointer(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: _dropDownMenuItems(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _value = value;
                                      },
                                    );
                                  },
                                  hint: Text("Select your vehicle"),
                                  value: _value,
                                  isExpanded: true,
                                  elevation: 0,
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
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
                        keyText: "Fuel cost/unit",
                        errorText: "Please enter proper fuel cost/unit",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
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
                        errorText:
                            "Please enter the total amount of fuel required",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _totalFuelExpenseEditingController,
                        keyText: "Total fuel expense",
                        errorText: "Please enter the total fuel cost",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        onChangeCallbackFunction: (distanceValue) {
                          _updateTripTime();
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
              Container(
                height: 0.152 * deviceHeight,
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
                        myController: _singleMealExpenseEditingController,
                        keyText: "Single meal expense",
                        errorText: "Please enter average cost of a single meal",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: false,
                        myController: _noOfMealsEditingController,
                        keyText: "No. of meals/day",
                        errorText: "Please enter the no. of meals/day",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _totalFoodExpenseEditingController,
                        keyText: "Total food expense",
                        errorText: "Please enter the total food expense",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
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
              Container(
                height: 0.11 * deviceHeight,
                width: 0.92 * deviceWidth,
                padding: EdgeInsets.only(
                  left: 0.04 * deviceWidth,
                  right: 0.025 * deviceWidth,
                  top: 0.001 * deviceWidth,
                  bottom: 0.02 * deviceWidth,
                ),
                margin: EdgeInsets.only(
                  left: 0.04 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
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
                        myController: _hotelCostEditingController,
                        keyText: "Hotel cost/night",
                        errorText: "Please enter average cost of a single meal",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                      ),
                      KeyValueRow(
                        toggleEdit: _toggleEdit,
                        readOnly: true,
                        myController: _totalHotelExpenseEditingController,
                        keyText: "Total hotel expense",
                        errorText: "Please enter the total hotel expense",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
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
              Container(
                height: 0.0655 * deviceHeight,
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
                        readOnly: true,
                        myController: _totalRideExpenseController,
                        keyText: "Total expense",
                        errorText: "Please enter total ride expense",
                        onTapCallbackNeeded: false,
                        onChangeCallbackNeeded: false,
                        textInputType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(\.\d*)?")),
                        ],
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
              (!widget.isPlanComplete)
                  ? ((!widget.isPlanActive)
                      ? Container(
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
                                if (widget.alreadyHasAnActivePlan) {
                                  _displayAlreadyAnotherPlanActiveAlert(
                                      deviceWidth, deviceHeight);
                                } else if (_formKey.currentState.validate()) {
                                  _displayActivateAlert(
                                      deviceWidth, deviceHeight);
                                }
                              },
                              child: Text(
                                "Activate",
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
                        )
                      : Container(
                          child: SizedBox(
                            height: 0.075 * deviceHeight,
                            width: 0.45 * deviceWidth,
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
                                  _displayCompleteAlert(
                                      deviceWidth, deviceHeight);
                                }
                              },
                              child: Text(
                                "Complete trip",
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
                        ))
                  : Container(),
              SizedBox(
                height: 0.02 * deviceHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
