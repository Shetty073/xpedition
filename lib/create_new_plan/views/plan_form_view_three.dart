import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/homepage/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/vehicle_data.dart';

class PlanFormViewThree extends StatefulWidget {
  final TextEditingController fromLocationController,
      toLocationController,
      vehicleNameController,
      fuelMileageController,
      fuelCostController;

  final List<VehicleData> myVehicleData;

  final myFormKey;

  final SharedPreferences myPref;

  PlanFormViewThree(
      {@required this.fromLocationController,
      @required this.toLocationController,
      @required this.vehicleNameController,
      @required this.fuelMileageController,
      @required this.fuelCostController,
      @required this.myVehicleData,
      @required this.myFormKey,
      @required this.myPref});

  @override
  _PlanFormViewThreeState createState() => _PlanFormViewThreeState();
}

class _PlanFormViewThreeState extends State<PlanFormViewThree> {
  String _value;

  List<DropdownMenuItem> _dropDownMenuItems() {
    List<DropdownMenuItem> dropdowmMenuItems = [];
    for (int i = 0; i < widget.myVehicleData.length; i++) {
      dropdowmMenuItems.add(
        DropdownMenuItem(
          value: widget.myVehicleData[i].vehicleName,
          child: Text(
            widget.myVehicleData[i].vehicleName,
            style:
                TextStyle(color: Theme.of(context).textTheme.headline2.color),
          ),
        ),
      );
    }
    return dropdowmMenuItems;
  }

  void _setVehicleMileage(String value) {
    for (int i = 0; i < widget.myVehicleData.length; i++) {
      if (widget.myVehicleData[i].vehicleName == value) {
        widget.fuelMileageController.text =
            widget.myVehicleData[i].vehicleMileage.toString();
      }
    }
  }

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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
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

  // for SimpleAutoCompleteTextField suggestions
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

  void _submitData() {
    // Set from and to locations ins SharedPreferences list for suggestions
    List<String> fromList = _getFromList();
    fromList.add(widget.fromLocationController.text);
    List<String> toList = _getToList();
    toList.add(widget.toLocationController.text);
    toList = toList.toSet().toList();
    fromList = fromList.toSet().toList();
    _setFromList(fromList);
    _setToList(toList);

    //TODO: submit data to database
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
