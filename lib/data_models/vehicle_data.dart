import 'package:flutter/cupertino.dart';

class VehicleData {
  String vehicleName;
  double vehicleMileage;

  VehicleData({@required this.vehicleName, @required this.vehicleMileage});

  Map<String, dynamic> toMap() {
    return {
      'vehicleName': vehicleName,
      'vehicleMileage': vehicleMileage
    };
  }

}
