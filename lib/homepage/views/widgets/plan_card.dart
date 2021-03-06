import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';
import 'package:xpedition/homepage/views/widgets/vertical_divider.dart';
import 'package:xpedition/view_edit_plan_page/view_edit_plan_page.dart';

class PlanCard extends StatefulWidget {
  final NewPlanDataWithId newPlanDataWithId;
  final String source, destination, beginDate;
  final int hrs, mins, days;
  final double totalDistance;
  final bool isPlanActive, alreadyHasAnActivePlan, isPlanComplete;
  final VoidCallback callBackFunction;

  PlanCard(
      {@required this.newPlanDataWithId,
      @required this.source,
      @required this.destination,
      @required this.beginDate,
      @required this.hrs,
      @required this.mins,
      @required this.days,
      @required this.totalDistance,
      @required this.isPlanActive,
      @required this.alreadyHasAnActivePlan,
      @required this.isPlanComplete,
      @required this.callBackFunction});

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  DatabaseHelper _myDbHelper;

  Future<List<VehicleDataWithId>> _getVehicleDataWithIdList() async {
    List<VehicleDataWithId> _vehicleDataWithIdList = [];
    _vehicleDataWithIdList = await _myDbHelper.getVehicleData();
    return _vehicleDataWithIdList;
  }

  Future<UserDataWithId> _getUserDataWithId() async {
    List<UserDataWithId> _userDataWithIdList = [];
    _userDataWithIdList = await _myDbHelper.getUserData();
    return _userDataWithIdList[0];
  }

  void _openViewEditPlanPage(List<VehicleDataWithId> vehicleDataWithIdList) {
    _getUserDataWithId().then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewEditPlanPage(
            newPlanDataWithId: widget.newPlanDataWithId,
            userDataWithId: value,
            vehicleDataWithIdList: vehicleDataWithIdList,
            isPlanActive: widget.isPlanActive,
            alreadyHasAnActivePlan: widget.alreadyHasAnActivePlan,
            isPlanComplete: widget.isPlanComplete,
            callBackFunction: widget.callBackFunction,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _myDbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _getVehicleDataWithIdList()
            .then((value) => _openViewEditPlanPage(value));
      },
      child: Container(
        height: 0.17 * deviceHeight,
        width: 0.9 * deviceWidth,
        padding: EdgeInsets.only(
            left: 0.025 * deviceWidth,
            right: 0.025 * deviceWidth,
            top: 0.025 * deviceWidth,
            bottom: 0.025 * deviceWidth),
        margin: EdgeInsets.only(
            left: 0.01 * deviceWidth,
            right: 0.01 * deviceWidth,
            top: 0.025 * deviceWidth,
            bottom: 0.025 * deviceWidth),
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headline4.color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).textTheme.headline5.color,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 0.27 * deviceWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "${widget.source}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.06 * deviceWidth,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.001 * deviceHeight,
                        ),
                        Text(
                          "to",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.001 * deviceHeight,
                        ),
                        Flexible(
                          child: Text(
                            "${widget.destination}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.06 * deviceWidth,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyVerticalDivider(
                    sidedBoxHeight: 0.2 * deviceWidth,
                    leftGap: 0.02 * deviceWidth,
                    rightGap: 0.02 * deviceHeight,
                    dividerWidth: 0.005 * deviceWidth,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Est. trip time: ",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "${widget.hrs} hrs ${widget.mins} mins",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.005 * deviceHeight,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "In days: ",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.days > 1
                                    ? "${widget.days} days"
                                    : "${widget.days} day",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.005 * deviceHeight,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Total distance: ",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${widget.totalDistance} KM",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.005 * deviceHeight,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Begin date: ",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${widget.beginDate}",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total ride expense: ",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 0.04 * deviceWidth,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "${widget.newPlanDataWithId.totalRideExpense}",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 0.04 * deviceWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
