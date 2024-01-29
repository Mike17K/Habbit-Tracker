import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habbittracker/models/action_model.dart';
import 'package:collection/collection.dart';
import 'package:habbittracker/services/crud/local_service.dart';

part 'actions_event.dart';
part 'actions_state.dart';

// TODO add database

class ActionsBloc extends Bloc<ActionsEvent, ActionsState> {
  LocalDatabaseService _localDatabaseService = LocalDatabaseService();

  ActionsBloc() : super(ActionsInitial()) {
    on<ActionEventsLoad>((event, emit) async {
      final actions = await _localDatabaseService.getExerciseActions();
      emit(ActionsLoaded(actions: actions));
    });

    on<ActionsTodayEventAdd>((event, emit) async {
      emit(await _handleTodayEventAdd(event));
    });

    on<ActionsTodayEventDelete>((event, emit) async {
      emit(await _handleTodayEventDelete(event));
    });
  }

  Future<ActionsState> _handleTodayEventAdd(ActionsTodayEventAdd event) async {
    if (state is ActionsLoaded) {
      final List<ExerciseAction> oldActions = (state as ActionsLoaded).actions;
      final List<ExerciseAction> newActions = List.from(oldActions)..add(event.action);
      _localDatabaseService.addExerciseAction(event.action);
      return ActionsLoaded(actions: newActions);
    }
    
    return state;
  }

  Future<ActionsState> _handleTodayEventDelete(ActionsTodayEventDelete event) async {
    if (state is ActionsLoaded) {
      final List<ExerciseAction> oldActions = (state as ActionsLoaded).actions;
      // find the index of the action to delete
      int index = oldActions.indexWhere((element) => element.id == event.action.id && element.date.day == event.action.date.day && element.date.month == event.action.date.month && element.date.year == event.action.date.year);
      final List<ExerciseAction> newActions = List.from(oldActions)..removeAt(index);
      _localDatabaseService.deleteExerciseAction(event.action.date);
      return ActionsLoaded(actions: newActions);
    }

    return state;
  }
}

