const String databaseName = 'habbittracker.db';
const String exerciseActionTableName = 'exercise_action';

const createExerciseActionTable = r'''
CREATE TABLE IF NOT EXISTS exercise_action (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exercise_name int NOT NULL,
  year int NOT NULL,
  month int NOT NULL,
  day int NOT NULL
)
''';

