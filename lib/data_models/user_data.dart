import 'package:flutter/cupertino.dart';

class UserData {
  final String firstName;
  final String lastName;
  final String vehicleName;
  final int maxKmInOneDay;
  final double vehicleMileage;
  final double fuelPricePerLitre;
  final double avgPriceOfOneMeal;
  final double avgPriceOfOneNightAtHotel;
  final int noOfMealsPerDay;

  UserData(
      {@required this.firstName,
      @required this.lastName,
      @required this.vehicleName,
      @required this.maxKmInOneDay,
      @required this.vehicleMileage,
      @required this.fuelPricePerLitre,
      @required this.avgPriceOfOneMeal,
      @required this.avgPriceOfOneNightAtHotel,
      @required this.noOfMealsPerDay});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'vehicleName': vehicleName,
      'maxKmInOneDay': maxKmInOneDay,
      'vehicleMileage': vehicleMileage,
      'fuelPricePerLitre': fuelPricePerLitre,
      'avgPriceOfOneMeal': avgPriceOfOneMeal,
      'avgPriceOfOneNightAtHotel': avgPriceOfOneNightAtHotel,
      'noOfMealsPerDay': noOfMealsPerDay
    };
  }

}
