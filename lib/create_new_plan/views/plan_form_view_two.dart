import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';

class PlanFormViewTwo extends StatefulWidget {
  final TextEditingController dateController, noOfDaysController, distanceController;

  final List<UserDataWithId> myUserData;

  PlanFormViewTwo(
      {@required this.dateController, @required this.noOfDaysController, @required this.myUserData, @required this.distanceController});

  @override
  _PlanFormViewTwoState createState() => _PlanFormViewTwoState();
}

class _PlanFormViewTwoState extends State<PlanFormViewTwo> {
  Future _selectDate() async {
    _totalTripDays();
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
        widget.dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  void _totalTripDays() {
    double tNoDays = (double.parse(widget.distanceController.text) / widget.myUserData[0].maxKmInOneDay);
    String totalTripDays = tNoDays.toString();
    List<String> decSplit;
    decSplit = totalTripDays.split(".");
    int preDec, postDec, totalDays;
    preDec = int.parse(decSplit[0]);
    postDec = int.parse(decSplit[1]);
    if(postDec != 0) {
      totalDays = preDec + 1;
    } else {
      totalDays = preDec;
    }
    setState(() {
      widget.noOfDaysController.text = totalDays.toString();
    });
  }

  @override
  void initState() {
    super.initState();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: false,
                  controller: widget.dateController,
                  decoration: InputDecoration(
                    hintText: "Select trip start date",
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "Please enter the trip start date";
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
                width: 0.02 * deviceWidth,
              ),
              Expanded(
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
                    onPressed: _selectDate,
                    child: Text(
                      "Select",
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
            ],
          ),
          SizedBox(
            height: 0.05 * deviceHeight,
          ),
          TextFormField(
            controller: widget.noOfDaysController,
            decoration: InputDecoration(
              hintText: "No. of days the trip will complete in",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Please enter the trip start date";
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
            onTap: () {
              _totalTripDays();
            },
          ),
        ],
      ),
    );
  }
}
