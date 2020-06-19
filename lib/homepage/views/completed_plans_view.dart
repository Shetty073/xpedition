import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/homepage/views/widgets/plan_card.dart';

class CompletedPlansView extends StatefulWidget {
  final List<NewPlanDataWithId> completedPlanDataList;
  CompletedPlansView({@required this.completedPlanDataList});

  @override
  _CompletedPlansViewState createState() => _CompletedPlansViewState();
}

class _CompletedPlansViewState extends State<CompletedPlansView> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 0.1 * deviceWidth,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 0.025 * deviceWidth,
                right: 0.025 * deviceWidth,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    " Completed trips:",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 0.05 * deviceWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.85 * deviceHeight,
              padding: EdgeInsets.only(
                left: 0.025 * deviceWidth,
                right: 0.025 * deviceWidth,
                top: 0.001 * deviceWidth,
                bottom: 0.025 * deviceWidth,
              ),
              child: (widget.completedPlanDataList.length > 0) ? ListView.builder(
                itemCount: widget.completedPlanDataList.length,
                itemBuilder: (context, i) {
                  return PlanCard(
                    newPlanDataWithId:
                    widget.completedPlanDataList[i],
                    source: widget.completedPlanDataList[i].source,
                    destination: widget.completedPlanDataList[i].destination,
                    beginDate: widget.completedPlanDataList[i].beginDate,
                    hrs: getHours(widget.completedPlanDataList[i]
                        .totalDistance),
                    mins: getMins(widget.completedPlanDataList[i]
                        .totalDistance),
                    days: widget.completedPlanDataList[i]
                        .totalNoOfDays,
                    totalDistance: widget.completedPlanDataList[i]
                        .totalDistance,
                    isPlanActive: false,
                    alreadyHasAnActivePlan:
                    _hasActivePlan,
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
