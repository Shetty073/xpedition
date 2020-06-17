import 'package:flutter/cupertino.dart';

// This class is specifically created for us to retrieve the INTEGER id (which is
// the PRIMARY KEY of our table) along with other data.
class NewPlanDataWithId {
  final int id;
  final String source, destination, beginDate, vehicleName;
  final double totalDistance,
      totalRideHotelExpense,
      totalRideFoodExpense,
      vehicleMileage,
      totalRideFuelRequired,
      totalRideFuelCost,
      totalRideExpense;
  final int totalNoOfDays, totalNoOfMealsPerDay;

  NewPlanDataWithId(
      {@required this.id,
      @required this.source,
      @required this.destination,
      @required this.beginDate,
      @required this.totalDistance,
      @required this.totalNoOfDays,
      @required this.totalRideHotelExpense,
      @required this.totalNoOfMealsPerDay,
      @required this.totalRideFoodExpense,
      @required this.vehicleName,
      @required this.vehicleMileage,
      @required this.totalRideFuelRequired,
      @required this.totalRideFuelCost,
      @required this.totalRideExpense});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "source": source,
      "destination": destination,
      "beginDate": beginDate,
      "totalDistance": totalDistance,
      "totalNoOfDays": totalNoOfDays,
      "totalRideHotelExpense": totalRideHotelExpense,
      "totalNoOfMealsPerDay": totalNoOfMealsPerDay,
      "totalRideFoodExpense": totalRideFoodExpense,
      "vehicleName": vehicleName,
      "vehicleMileage": vehicleMileage,
      "totalRideFuelRequired": totalRideFuelRequired,
      "totalRideFuelCost": totalRideFuelCost,
      "totalRideExpense": totalRideExpense,
    };
  }
}
