part of 'actions_bloc.dart';

abstract class ActionsEvent extends Equatable {
  const ActionsEvent();

  @override
  List<Object?> get props => [];
}

class ActionEventsLoad extends ActionsEvent { }

class ActionsTodayEventAdd extends ActionsEvent {
  final ExerciseAction action;

  const ActionsTodayEventAdd({
    required this.action,
  });

  @override
  List<Object?> get props => [action];
}

class ActionsTodayEventDelete extends ActionsEvent {
  final ExerciseAction action;

  const ActionsTodayEventDelete({
    required this.action,
  });

  @override
  List<Object?> get props => [action];
}