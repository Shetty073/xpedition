import 'package:flutter/cupertino.dart';

// This class is specifically created for us to retrieve the INTEGER id (which is
// the PRIMARY KEY of our table) along with other data.
class UserDataWithId {
  final int id, maxKmInOneDay, noOfMealsPerDay;
  final String firstName, lastName;
  final double fuelPricePerLitre, avgPriceOfOneMeal, avgPriceOfOneNightAtHotel;

  UserDataWithId(
      {@required this.id,
      @required this.firstName,
      @required this.lastName,
      @required this.maxKmInOneDay,
      @required this.fuelPricePerLitre,
      @required this.avgPriceOfOneMeal,
      @required this.avgPriceOfOneNightAtHotel,
      @required this.noOfMealsPerDay});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'maxKmInOneDay': maxKmInOneDay,
      'fuelPricePerLitre': fuelPricePerLitre,
      'avgPriceOfOneMeal': avgPriceOfOneMeal,
      'avgPriceOfOneNightAtHotel': avgPriceOfOneNightAtHotel,
      'noOfMealsPerDay': noOfMealsPerDay,
    };
  }
}
