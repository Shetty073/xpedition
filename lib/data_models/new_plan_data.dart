import 'package:flutter/cupertino.dart';

class NewPlanData {
  final String source, destination, beginDate, vehicleName;
  final double totalDistance,
      totalRideHotelExpense,
      totalRideFoodExpense,
      vehicleMileage,
      totalRideFuelRequired,
      totalRideFuelCost,
      totalRideExpense;
  final int totalNoOfDays, totalNoOfMealsPerDay;

  NewPlanData(
      {@required this.source,
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
