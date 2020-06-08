import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpedition/homepage/views/query_helper/query_helper.dart';
import 'package:xpedition/homepage/views/widgets/plan_card.dart';

class PlansView extends StatefulWidget {
  @override
  _PlansViewState createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  QueryHelper _queryHelper = QueryHelper();
  SharedPreferences myPref;
  bool _containsKey;

  // When we use google maps offline, google uses the following formula to
  // get ETA from source to destination: (totalDistance / 40) where 40 is the
  // average speed of the vehicle
  int getHours(double distance) {
    List<String> res = (distance / 40).toString().split(".");
    return int.parse(res[0]);
  }

  int getMins(double distance) {
    List<String> res = (distance / 40).toString().split(".");
    if(res[1].length > 2) {
      return int.parse(res[1].substring(0, 2));
    }
    return int.parse(res[1]);
  }


  void _initSharedPref() async {
    myPref = await SharedPreferences.getInstance();
    setState(() {
      _containsKey = myPref.containsKey("complete_init_setup");
    });
  }

  @override
  void initState() {
    super.initState();
    _containsKey = false;
    _initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return (_containsKey) ? Container(
      padding: EdgeInsets.only(
          left: 0.025 * deviceWidth,
          right: 0.025 * deviceWidth,
          top: 0.025 * deviceWidth,
          bottom: 0.025 * deviceWidth),
      child: FutureBuilder(
        future: _queryHelper.getDataFromDatabase(),
        builder: (context, snapshot) {
          return (snapshot.hasData) ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return PlanCard(
                newPlanDataWithId: snapshot.data[i],
                source: snapshot.data[i].source,
                destination: snapshot.data[i].destination,
                beginDate: snapshot.data[i].beginDate,
                hrs: getHours(snapshot.data[i].totalDistance),
                mins: getMins(snapshot.data[i].totalDistance),
                days: snapshot.data[i].totalNoOfDays,
                totalDistance: snapshot.data[i].totalDistance,
              );
            },
          ) : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No plans to show.",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),
                SizedBox(
                  height: 0.001 * deviceHeight,
                ),
                Text(
                  "Create a new one by clicking on the + button",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ) : Center(
      child: Text(
        "Please first complete initial setup.",
        style: TextStyle(
          color: Theme.of(context).textTheme.headline2.color,
        ),
      ),
    );
  }
}
