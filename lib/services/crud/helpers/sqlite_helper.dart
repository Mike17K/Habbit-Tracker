import 'package:habbittracker/constants/database.dart';
import 'package:habbittracker/models/action_model.dart';
import 'package:habbittracker/services/crud/crud_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseOversightService {
  Future<void> open();
  // Open the database if it is not already open.

  Future<void> close();
  // Close the database if it is open.

  Future<void> clearDatabase();
  // Delete all data from the database.

  Future<Database> getDatabase();
  // Get the database. If the database is not open, open it first.
}

class SQLiteService implements DatabaseOversightService{
  Database? _db;
  bool isDbOpen = false;
  
  static final SQLiteService _shared = SQLiteService._sharedInstance();
  SQLiteService._sharedInstance();
  factory SQLiteService() => _shared;
  
  // Function Implementations
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }
  
  Future<void> _ensureDbIsOpen() async {
    if (isDbOpen) return;
    try {
      await open();
      isDbOpen = true;
    } on DatabaseAlreadyOpenedException {
      // empty
    }
  }

  @override
  Future<Database> getDatabase() async {
    await _ensureDbIsOpen();
    return _getDatabaseOrThrow();
  }

  @override
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, databaseName);
      final db = await openDatabase(dbPath);
      _db = db;
      
      // create collections table
      await db.execute(createExerciseActionTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }
  
  @override
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  @override
  Future<void> clearDatabase() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.delete(exerciseActionTableName);
  }

  // Exercise Action Table
  Future<void> insertExerciseAction(ExerciseAction action) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(exerciseActionTableName, action.toMap());
  }

  Future<List<ExerciseAction>> getExerciseActions() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final List<Map<String, dynamic>> maps = await db.query(exerciseActionTableName);
    return List.generate(maps.length, (i) {
      return ExerciseAction.fromMap(maps[i]);
    });
  }

  Future<void> deleteExerciseAction(DateTime date) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final List<Map<String, dynamic>> maps = await db.query(exerciseActionTableName, where: 'year = ? AND month = ? AND day = ?', whereArgs: [date.year, date.month, date.day]);
    final firstRes = maps.first;
    await db.delete(exerciseActionTableName, where: 'id = ?', whereArgs: [firstRes['id']]);
  }

  Future<List<ExerciseAction>> getTodayExercuseActionsByExerciseName(String name) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final List<Map<String, dynamic>> maps = await db.query(exerciseActionTableName, where: 'exercise_name = ? AND year = ? AND month = ? AND day = ?', whereArgs: [name, DateTime.now().year, DateTime.now().month, DateTime.now().day]);
    return List.generate(maps.length, (i) {
      return ExerciseAction.fromMap(maps[i]);
    });
  }
}
