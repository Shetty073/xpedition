import 'package:sqflite/sqflite.dart';
import 'package:xpedition/data_models/vehicle_data.dart';
import 'package:xpedition/data_models/user_data.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  Future<Database> database;

  DatabaseHelper() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'app_data.db'),
    );
  }

  Future<void> createUserDataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE user_data(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, maxKmInOneDay INTEGER, fuelPricePerLitre REAL, avgPriceOfOneMeal REAL, avgPriceOfOneNightAtHotel REAL, noOfMealsPerDay INTEGER)");
  }

  Future<void> insertUserData(UserData userData) async {
    // Get a reference to the database.
    final Database db = await database;
    await db.insert(
      'user_data',
      userData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> createVehicleDataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE vehicle_data(id INTEGER PRIMARY KEY AUTOINCREMENT, vehicleName TEXT, vehicleMileage REAL)");
  }

  Future<void> insertVehicleData(VehicleData vehicleData) async {
    final Database db = await database;
    await db.insert(
      'vehicle_data',
      vehicleData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VehicleData>> getVehicleData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> vehicleDataMaps = await db.query('vehicle_data');
    return List.generate(vehicleDataMaps.length, (i) {
      return VehicleData(
        vehicleName: vehicleDataMaps[i]['vehicleName'],
        vehicleMileage: vehicleDataMaps[i]['vehicleMileage'],
      );
    });
  }
}
