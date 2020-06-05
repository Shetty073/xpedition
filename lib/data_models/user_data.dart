import 'package:flutter/cupertino.dart';

class UserData {
  final String firstName;
  final String lastName;
  final int maxKmInOneDay;
  final double fuelPricePerLitre;
  final double avgPriceOfOneMeal;
  final double avgPriceOfOneNightAtHotel;
  final int noOfMealsPerDay;

  UserData(
      {@required this.firstName,
      @required this.lastName,
      @required this.maxKmInOneDay,
      @required this.fuelPricePerLitre,
      @required this.avgPriceOfOneMeal,
      @required this.avgPriceOfOneNightAtHotel,
      @required this.noOfMealsPerDay});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'maxKmInOneDay': maxKmInOneDay,
      'fuelPricePerLitre': fuelPricePerLitre,
      'avgPriceOfOneMeal': avgPriceOfOneMeal,
      'avgPriceOfOneNightAtHotel': avgPriceOfOneNightAtHotel,
      'noOfMealsPerDay': noOfMealsPerDay
    };
  }

}
