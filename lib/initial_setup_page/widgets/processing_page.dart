import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProcessingPage extends StatefulWidget {
  @override
  _ProcessingPageState createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SpinKitWave(
            size: 0.1 * deviceWidth,
            color: Theme.of(context).textTheme.headline1.color,
          ),
          Text(
            "please wait...",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
            ),
          ),
        ],
      ),
    );
  }
}
