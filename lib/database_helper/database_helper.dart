import 'package:sqflite/sqflite.dart';
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

  Future<void> createUserdataTable() async {
    final Database db = await database;
    db.execute(
        "CREATE TABLE user_data(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, vehicleName TEXT, maxKmInOneDay INTEGER, vehicleMileage REAL, fuelPricePerLitre REAL, avgPriceOfOneMeal REAL, avgPriceOfOneNightAtHotel REAL, noOfMealsPerDay INTEGER)");
  }

  Future<void> insertUserdata(UserData userData) async {
    // Get a reference to the database.
    final Database db = await database;

    await db.insert(
      'user_data',
      userData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
