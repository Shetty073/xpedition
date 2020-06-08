import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanFormViewOne extends StatefulWidget {
  final TextEditingController fromLocationController,
      toLocationController,
      distanceController;

  final SharedPreferences myPref;

  PlanFormViewOne(
      {@required this.fromLocationController,
      @required this.toLocationController,
      @required this.distanceController,
      @required this.myPref});

  @override
  _PlanFormViewOneState createState() => _PlanFormViewOneState();
}

class _PlanFormViewOneState extends State<PlanFormViewOne> {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey;
  bool _fromTextError;
  bool _toTextError;
  FocusNode _fromFocusNode = FocusNode();
  FocusNode _toFocusNode = FocusNode();

  // for SimpleAutoCompleteTextField suggestions
  List<String> _getFromList() {
    return widget.myPref.getStringList("fromList");
  }

  List<String> _getToList() {
    return widget.myPref.getStringList("toList");
  }

  //FIXME: Error text not working for some reason
  void _onFromFocusChange() {
    if (!_fromFocusNode.hasFocus) {
      if (widget.fromLocationController.text.trim().isEmpty) {
        setState(() {
          _fromTextError = true;
        });
      } else {
        setState(() {
          _fromTextError = false;
        });
      }
    }
  }

  void _onToFocusChange() {
    if (!_toFocusNode.hasFocus) {
      if (widget.toLocationController.text.trim().isEmpty) {
        setState(() {
          _toTextError = true;
        });
      } else {
        setState(() {
          _toTextError = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fromTextError = false;
    _toTextError = false;
    _fromFocusNode.addListener(_onFromFocusChange);
    _toFocusNode.addListener(_onToFocusChange);
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
          SimpleAutoCompleteTextField(
            key: autoCompleteKey,
            suggestions: _getFromList(),
            controller: widget.fromLocationController,
            decoration: InputDecoration(
              hintText: "Begin location",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              errorText: _fromTextError ? "Please enter start location for your trip" :  null,
              errorStyle: TextStyle(
                color: Colors.red,
              ),
            ),
            clearOnSubmit: false,
            submitOnSuggestionTap: true,
            keyboardType: TextInputType.text,
            suggestionsAmount: 5,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            focusNode: _fromFocusNode,
          ),
          SizedBox(
            height: 0.05 * deviceHeight,
          ),
          SimpleAutoCompleteTextField(
            key: autoCompleteKey,
            suggestions: _getToList(),
            controller: widget.toLocationController,
            decoration: InputDecoration(
              hintText: "Destination",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              errorText: _toTextError ? "Please enter destination location for your trip" :  null,
              errorStyle: TextStyle(
                color: Colors.red,
              ),
            ),
            clearOnSubmit: false,
            submitOnSuggestionTap: true,
            keyboardType: TextInputType.text,
            suggestionsAmount: 5,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            focusNode: _toFocusNode,
          ),
          SizedBox(
            height: 0.05 * deviceHeight,
          ),
          TextFormField(
            controller: widget.distanceController,
            decoration: InputDecoration(
              hintText: "Total distance",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r"^\d+(\.\d*)?")),
            ],
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Please enter the total distance between source and destination";
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
            height: 0.05 * deviceHeight,
          ),
        ],
      ),
    );
  }
}
