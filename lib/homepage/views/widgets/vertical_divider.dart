import 'package:flutter/material.dart';

class MyVerticalDivider extends StatefulWidget {
  final double sidedBoxHeight, leftGap, rightGap, dividerWidth;

  MyVerticalDivider(
      {@required this.sidedBoxHeight,
      @required this.leftGap,
      @required this.rightGap,
      @required this.dividerWidth});

  @override
  _MyVerticalDividerState createState() => _MyVerticalDividerState();
}

class _MyVerticalDividerState extends State<MyVerticalDivider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.sidedBoxHeight,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: widget.leftGap,
            right: widget.rightGap,
          ),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).textTheme.headline2.color,
                width: widget.dividerWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
