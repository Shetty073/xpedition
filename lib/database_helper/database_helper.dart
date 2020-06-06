import 'package:sqflite/sqflite.dart';
import 'package:xpedition/data_models/new_plan_data.dart';
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

  Future<List<UserData>> getUserData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> userDataMaps = await db.query('user_data');
    return List.generate(userDataMaps.length, (i) {
      return UserData(
        firstName: userDataMaps[i]['firstName'],
        lastName: userDataMaps[i]['lastName'],
        maxKmInOneDay: userDataMaps[i]['maxKmInOneDay'],
        fuelPricePerLitre: userDataMaps[i]['fuelPricePerLitre'],
        avgPriceOfOneMeal: userDataMaps[i]['avgPriceOfOneMeal'],
        avgPriceOfOneNightAtHotel: userDataMaps[i]['avgPriceOfOneNightAtHotel'],
        noOfMealsPerDay: userDataMaps[i]['noOfMealsPerDay'],
      );
    });
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
    final List<Map<String, dynamic>> vehicleDataMaps =
        await db.query('vehicle_data');
    return List.generate(vehicleDataMaps.length, (i) {
      return VehicleData(
        vehicleName: vehicleDataMaps[i]['vehicleName'],
        vehicleMileage: vehicleDataMaps[i]['vehicleMileage'],
      );
    });
  }

  Future<void> createNewPlanDataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE new_plan_data(id INTEGER PRIMARY KEY AUTOINCREMENT, source TEXT, destination TEXT, totalDistance REAL, totalNoOfDays INTEGER, totalRideHotelExpense REAL, totalRideFoodExpense REAL, vehicleMileage REAL, totalRideFuelRequired REAL, totalRideFuelCost REAL, totalRideExpense REAL)");
  }

  Future<void> insertNewPlanData(NewPlanData newPlanData) async {
    final Database db = await database;
    await db.insert(
      'new_plan_data',
      newPlanData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewPlanData>> getNewPlanData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> newPlanDataMaps =
        await db.query('vehicle_data');
    return List.generate(newPlanDataMaps.length, (i) {
      return NewPlanData(
        source: newPlanDataMaps[i]['source'],
        destination: newPlanDataMaps[i]['destination'],
        totalDistance: newPlanDataMaps[i]['totalDistance'],
        totalNoOfDays: newPlanDataMaps[i]['totalNoOfDays'],
        totalRideHotelExpense: newPlanDataMaps[i]['totalRideHotelExpense'],
        totalRideFoodExpense: newPlanDataMaps[i]['totalRideFoodExpense'],
        vehicleMileage: newPlanDataMaps[i]['vehicleMileage'],
        totalRideFuelRequired: newPlanDataMaps[i]['totalRideFuelRequired'],
        totalRideFuelCost: newPlanDataMaps[i]['totalRideFuelCost'],
        totalRideExpense: newPlanDataMaps[i]['totalRideExpense'],
      );
    });
  }
}
