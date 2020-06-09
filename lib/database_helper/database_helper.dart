import 'package:sqflite/sqflite.dart';
import 'package:xpedition/data_models/new_plan_data.dart';
import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/data_models/vehicle_data.dart';
import 'package:xpedition/data_models/user_data.dart';
import 'package:path/path.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';
import 'dart:async';

import 'package:xpedition/data_models/with_id/vehicle_data_with_id.dart';

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

  Future<List<UserDataWithId>> getUserData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> userDataMapsWithId = await db.query('user_data');
    return List.generate(userDataMapsWithId.length, (i) {
      return UserDataWithId(
        id: userDataMapsWithId[i]['id'],
        firstName: userDataMapsWithId[i]['firstName'],
        lastName: userDataMapsWithId[i]['lastName'],
        maxKmInOneDay: userDataMapsWithId[i]['maxKmInOneDay'],
        fuelPricePerLitre: userDataMapsWithId[i]['fuelPricePerLitre'],
        avgPriceOfOneMeal: userDataMapsWithId[i]['avgPriceOfOneMeal'],
        avgPriceOfOneNightAtHotel: userDataMapsWithId[i]['avgPriceOfOneNightAtHotel'],
        noOfMealsPerDay: userDataMapsWithId[i]['noOfMealsPerDay'],
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

  Future<List<VehicleDataWithId>> getVehicleData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> vehicleDataMapsWithId =
        await db.query('vehicle_data');
    return List.generate(vehicleDataMapsWithId.length, (i) {
      return VehicleDataWithId(
        id: vehicleDataMapsWithId[i]['id'],
        vehicleName: vehicleDataMapsWithId[i]['vehicleName'],
        vehicleMileage: vehicleDataMapsWithId[i]['vehicleMileage'],
      );
    });
  }

  Future<void> createNewPlanDataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE new_plan_data(id INTEGER PRIMARY KEY AUTOINCREMENT, source TEXT, destination TEXT, beginDate TEXT, totalDistance REAL, totalNoOfDays INTEGER, totalRideHotelExpense REAL, totalRideFoodExpense REAL, vehicleName TEXT, vehicleMileage REAL, totalRideFuelRequired REAL, totalRideFuelCost REAL, totalRideExpense REAL)");
  }

  Future<void> insertNewPlanData(NewPlanData newPlanData) async {
    final Database db = await database;
    await db.insert(
      'new_plan_data',
      newPlanData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewPlanDataWithId>> getNewPlanData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> newPlanDataMapsWithId =
        await db.query('new_plan_data');
    return List.generate(newPlanDataMapsWithId.length, (i) {
      return NewPlanDataWithId(
        id: newPlanDataMapsWithId[i]['id'],
        source: newPlanDataMapsWithId[i]['source'],
        destination: newPlanDataMapsWithId[i]['destination'],
        beginDate: newPlanDataMapsWithId[i]['beginDate'],
        totalDistance: newPlanDataMapsWithId[i]['totalDistance'],
        totalNoOfDays: newPlanDataMapsWithId[i]['totalNoOfDays'],
        totalRideHotelExpense: newPlanDataMapsWithId[i]['totalRideHotelExpense'],
        totalRideFoodExpense: newPlanDataMapsWithId[i]['totalRideFoodExpense'],
        vehicleName: newPlanDataMapsWithId[i]['vehicleName'],
        vehicleMileage: newPlanDataMapsWithId[i]['vehicleMileage'],
        totalRideFuelRequired: newPlanDataMapsWithId[i]['totalRideFuelRequired'],
        totalRideFuelCost: newPlanDataMapsWithId[i]['totalRideFuelCost'],
        totalRideExpense: newPlanDataMapsWithId[i]['totalRideExpense'],
      );
    });
  }

  Future<void> updateNewPlanData(NewPlanDataWithId newPlanDataWithId) async {
    final Database db = await database;
    await db.update(
      'new_plan_data',
      newPlanDataWithId.toMap(),
      where: "id = ?",
      whereArgs: [newPlanDataWithId.id],
    );
  }

  Future<void> deleteNewPlanData(NewPlanDataWithId newPlanDataWithId) async {
    final Database db = await database;
    await db.delete(
      'new_plan_data',
      where: "id = ?",
      whereArgs: [newPlanDataWithId.id],
    );
  }

  Future<void> createActivePlanDataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE active_plan_data(id INTEGER PRIMARY KEY AUTOINCREMENT, source TEXT, destination TEXT, beginDate TEXT, totalDistance REAL, totalNoOfDays INTEGER, totalRideHotelExpense REAL, totalRideFoodExpense REAL, vehicleName TEXT, vehicleMileage REAL, totalRideFuelRequired REAL, totalRideFuelCost REAL, totalRideExpense REAL)");
  }

  Future<void> insertActivePlanData(NewPlanData newPlanData) async {
    final Database db = await database;
    await db.insert(
      'active_plan_data',
      newPlanData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewPlanDataWithId>> getActivePlanData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> newPlanDataMapsWithId =
    await db.query('active_plan_data');
    return List.generate(newPlanDataMapsWithId.length, (i) {
      return NewPlanDataWithId(
        id: newPlanDataMapsWithId[i]['id'],
        source: newPlanDataMapsWithId[i]['source'],
        destination: newPlanDataMapsWithId[i]['destination'],
        beginDate: newPlanDataMapsWithId[i]['beginDate'],
        totalDistance: newPlanDataMapsWithId[i]['totalDistance'],
        totalNoOfDays: newPlanDataMapsWithId[i]['totalNoOfDays'],
        totalRideHotelExpense: newPlanDataMapsWithId[i]['totalRideHotelExpense'],
        totalRideFoodExpense: newPlanDataMapsWithId[i]['totalRideFoodExpense'],
        vehicleName: newPlanDataMapsWithId[i]['vehicleName'],
        vehicleMileage: newPlanDataMapsWithId[i]['vehicleMileage'],
        totalRideFuelRequired: newPlanDataMapsWithId[i]['totalRideFuelRequired'],
        totalRideFuelCost: newPlanDataMapsWithId[i]['totalRideFuelCost'],
        totalRideExpense: newPlanDataMapsWithId[i]['totalRideExpense'],
      );
    });
  }

}
