import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PlanFormViewTwo extends StatefulWidget {
  final TextEditingController dateController, noOfDaysController;

  PlanFormViewTwo({@required this.dateController, @required this.noOfDaysController});

  @override
  _PlanFormViewTwoState createState() => _PlanFormViewTwoState();
}

class _PlanFormViewTwoState extends State<PlanFormViewTwo> {

  Future _selectDate() async {
    print("lol");
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2050));
    if (picked != null) {
      setState(() {
        widget.dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
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
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
          ),
        ],
      ),
    );
  }
}
