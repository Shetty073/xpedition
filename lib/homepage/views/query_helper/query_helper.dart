import 'package:xpedition/data_models/with_id/new_plan_data_with_id.dart';
import 'package:xpedition/database_helper/database_helper.dart';

// Get data required to show on cards from the sqlite database.
class QueryHelper {
  DatabaseHelper _myDbHelper = DatabaseHelper();

  // Notice that here instead of using NewPlanData class we are using NewPlanDataWithId
  // which returns the id (INTEGER PRIMARY KEY of the table) alongside the data.
  // The id is the only unique key in the entire table hence it is required to make
  // any changes to a particular row.
  Future<List<NewPlanDataWithId>> getNewPlanDataFromDatabase() async {
    List<NewPlanDataWithId> newPlansList = await _myDbHelper.getNewPlanData();
    return newPlansList;
  }

  Future<List<NewPlanDataWithId>> getActivePlanDataFromDatabase() async {
    List<NewPlanDataWithId> activePlansList =
        await _myDbHelper.getActivePlanData();
    return activePlansList;
  }

  Future<List<NewPlanDataWithId>> getCompletedPlanDataFromDatabase() async {
    List<NewPlanDataWithId> completedPlansList =
        await _myDbHelper.getCompletedPlanData();
    return completedPlansList;
  }
}
