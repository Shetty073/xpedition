import 'package:flutter/material.dart';

class PlansView extends StatefulWidget {
  @override
  _PlansViewState createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "planslist",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

