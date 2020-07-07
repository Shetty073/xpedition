import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyValueRow extends StatefulWidget {
  final TextEditingController myController;
  final bool toggleEdit,
      onTapCallbackNeeded,
      readOnly,
      onChangeCallbackNeeded,
      isTotal;
  final String keyText, errorText;
  final TextInputType textInputType;

  final List<dynamic> inputFormatters;

  final onTapCallbackFunction, onChangeCallbackFunction;

  KeyValueRow({
    @required this.toggleEdit,
    @required this.readOnly,
    @required this.myController,
    @required this.keyText,
    @required this.errorText,
    @required this.onTapCallbackNeeded,
    this.onTapCallbackFunction,
    @required this.onChangeCallbackNeeded,
    this.onChangeCallbackFunction,
    @required this.textInputType,
    this.inputFormatters,
    this.isTotal,
  });

  @override
  _KeyValueRowState createState() => _KeyValueRowState();
}

class _KeyValueRowState extends State<KeyValueRow> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 0.075 * deviceWidth,
      child: Row(
        children: <Widget>[
          Text(
            "${widget.keyText}:",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 0.045 * deviceWidth,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
          ),
          SizedBox(
            width: 0.01 * deviceWidth,
          ),
          Flexible(
            child: TextFormField(
              onTap: widget.onTapCallbackNeeded
                  ? widget.onTapCallbackFunction
                  : () {},
              onChanged: widget.onChangeCallbackNeeded
                  ? widget.onChangeCallbackFunction
                  : (val) {},
              enabled: widget.toggleEdit,
              readOnly: widget.readOnly,
              controller: widget.myController,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: (widget.readOnly && !widget.onTapCallbackNeeded)
                    ? InputBorder.none
                    : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                focusedBorder: (widget.readOnly && !widget.onTapCallbackNeeded)
                    ? InputBorder.none
                    : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "${widget.errorText}";
                }
                return null;
              },
              keyboardType: widget.textInputType,
              inputFormatters: widget.inputFormatters,
              autocorrect: true,
              autofocus: false,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontWeight: (widget.isTotal == null)
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
