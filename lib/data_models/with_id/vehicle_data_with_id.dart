import 'package:flutter/cupertino.dart';

// This class is specifically created for us to retrieve the INTEGER id (which is
// the PRIMARY KEY of our table) along with other data.
class VehicleDataWithId {
  final int id;
  final String vehicleName;
  final double vehicleMileage;

  VehicleDataWithId({@required this.id, @required this.vehicleName, @required this.vehicleMileage});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleName': vehicleName,
      'vehicleMileage': vehicleMileage,
    };
  }
}
