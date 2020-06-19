import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/homepage/views/widgets/plan_card.dart';

class CompletedPlansView extends StatefulWidget {
  final List<NewPlanDataWithId> completedPlanDataList;
  CompletedPlansView({@required this.completedPlanDataList});

  @override
  _CompletedPlansViewState createState() => _CompletedPlansViewState();
}

class _CompletedPlansViewState extends State<CompletedPlansView> {
  List<NewPlanDataWithId> _completedPlanDataList;
  DatabaseHelper _myDbHelper;
  bool _hasActivePlan = false;

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

  void _updateListViewData() async {
    _completedPlanDataList = await _myDbHelper.getCompletedPlanData();
  }

  @override
  void initState() {
    super.initState();
    _myDbHelper = DatabaseHelper();
    _completedPlanDataList = widget.completedPlanDataList;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 0.026 * deviceWidth),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "Completed trips",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[

            Container(
              height: 0.85 * deviceHeight,
              padding: EdgeInsets.only(
                left: 0.025 * deviceWidth,
                right: 0.025 * deviceWidth,
                top: 0.001 * deviceWidth,
                bottom: 0.025 * deviceWidth,
              ),
              child: (_completedPlanDataList.length > 0) ? ListView.builder(
                itemCount: _completedPlanDataList.length,
                itemBuilder: (context, i) {
                  return PlanCard(
                    newPlanDataWithId: _completedPlanDataList[i],
                    source: _completedPlanDataList[i].source,
                    destination: _completedPlanDataList[i].destination,
                    beginDate: _completedPlanDataList[i].beginDate,
                    hrs: getHours(_completedPlanDataList[i]
                        .totalDistance),
                    mins: getMins(_completedPlanDataList[i]
                        .totalDistance),
                    days: _completedPlanDataList[i]
                        .totalNoOfDays,
                    totalDistance: _completedPlanDataList[i]
                        .totalDistance,
                    isPlanActive: false,
                    isPlanComplete: true,
                    alreadyHasAnActivePlan: _hasActivePlan,
                    callBackFunction: () {
                      setState(() {
                        _updateListViewData();
                      });
                    },
                  );
                },
              ) : Container(
                child: Center(
                  child: Text(
                    "No plans to show",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 0.02 * deviceWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
