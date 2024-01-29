import 'package:equatable/equatable.dart';

class ExerciseAction extends Equatable {
  final int id;
  final DateTime date;

  const ExerciseAction({

    required this.id,
    required this.date,
  });

  @override
  List<Object?> get props => [id, date];

  Map<String, dynamic> toMap() {
    return {
      'id': null,
      'exercise_name': id,
      'year': date.year,
      'month': date.month,
      'day': date.day,
    };
  }

  ExerciseAction.fromMap(Map<String, dynamic> map)
      : id = map['exercise_name'],
        date = DateTime(map['year'], map['month'], map['day']);
}
