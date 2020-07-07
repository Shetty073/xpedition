import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isInitialSetupCompleteKey;
  bool _firstLaunch;
  bool _hasActivePlan = false;

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

  void _initSharedPref() async {
    myPref = await SharedPreferences.getInstance();
    setState(() {
      _isInitialSetupCompleteKey = myPref.containsKey("complete_init_setup");
    });
  }

  Widget _firstLaunchRefresh(double deviceWidth) {
    Future.delayed(Duration(seconds: 2), () {
      if (this.mounted) {
        setState(() {
          // NOTE: This is kept empty on purpose
        });
      }
    });
    return SpinKitWave(
      color: Theme.of(context).primaryColor,
      size: 0.1 * deviceWidth,
    );
  }

  @override
  void initState() {
    super.initState();
    _isInitialSetupCompleteKey = false;
    _initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 0.025 * deviceWidth,
        right: 0.025 * deviceWidth,
        top: 0.025 * deviceWidth,
        bottom: 0.005 * deviceWidth,
      ),
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: _queryHelper.getActivePlanDataFromDatabase(),
            builder: (context, snapshot) {
              _hasActivePlan =
                  ((snapshot.hasData) && (snapshot.data.length > 0))
                      ? true
                      : false;
              return (_hasActivePlan)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          " Active trip:",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 0.05 * deviceWidth,
                            ),
                          ),
                        ),
                        Container(
                          child: PlanCard(
                            newPlanDataWithId: snapshot.data[0],
                            source: snapshot.data[0].source,
                            destination: snapshot.data[0].destination,
                            beginDate: snapshot.data[0].beginDate,
                            hrs: getHours(snapshot.data[0].totalDistance),
                            mins: getMins(snapshot.data[0].totalDistance),
                            days: snapshot.data[0].totalNoOfDays,
                            totalDistance: snapshot.data[0].totalDistance,
                            isPlanActive: true,
                            isPlanComplete: false,
                            alreadyHasAnActivePlan: _hasActivePlan,
                            callBackFunction: () {},
                          ),
                          width: deviceWidth,
                        ),
                        SizedBox(
                          height: 0.03 * deviceHeight,
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: _queryHelper.getNewPlanDataFromDatabase(),
              builder: (context, snapshot) {
                return (snapshot.hasData)
                    ? ((snapshot.data.length > 0)
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " Upcoming trips:",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 0.05 * deviceWidth,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return PlanCard(
                                        newPlanDataWithId: snapshot.data[i],
                                        source: snapshot.data[i].source,
                                        destination:
                                            snapshot.data[i].destination,
                                        beginDate: snapshot.data[i].beginDate,
                                        hrs: getHours(
                                            snapshot.data[i].totalDistance),
                                        mins: getMins(
                                            snapshot.data[i].totalDistance),
                                        days: snapshot.data[i].totalNoOfDays,
                                        totalDistance:
                                            snapshot.data[i].totalDistance,
                                        isPlanActive: false,
                                        isPlanComplete: false,
                                        alreadyHasAnActivePlan: _hasActivePlan,
                                        callBackFunction: () {},
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "No new plans to show.",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                  ),
                                ),
                                SizedBox(
                                  height: 0.001 * deviceHeight,
                                ),
                                Text(
                                  "Create a new one by clicking on the + button",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    : _firstLaunchRefresh(deviceWidth);
              },
            ),
          ),
        ],
      ),
    );
  }
}
