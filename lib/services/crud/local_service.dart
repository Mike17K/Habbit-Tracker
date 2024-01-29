
import 'package:habbittracker/models/action_model.dart';
import 'package:habbittracker/services/crud/helpers/sqlite_helper.dart';

class LocalDatabaseService {
  final SQLiteService _sqliteService = SQLiteService();

  static final LocalDatabaseService _shared =
      LocalDatabaseService._sharedInstance();
  LocalDatabaseService._sharedInstance() {
    _sqliteService.open();}
  factory LocalDatabaseService() => _shared;

  Future<void> clearDatabase() async {
    _sqliteService.clearDatabase();
  }

  Future<void> addExerciseAction(ExerciseAction action) async {
    await _sqliteService.insertExerciseAction(action);
  }

  Future<void> deleteExerciseAction(DateTime date) async {
    await _sqliteService.deleteExerciseAction(date);
  }

  Future<List<ExerciseAction>> getExerciseActions() async {
    return await _sqliteService.getExerciseActions();
  }

  Future<void> getTodayExercuseActionsByExerciseName(String name) async {
    await _sqliteService.getTodayExercuseActionsByExerciseName(name);
  }
}