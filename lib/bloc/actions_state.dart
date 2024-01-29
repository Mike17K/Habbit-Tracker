part of 'actions_bloc.dart';

abstract class ActionsState extends Equatable {
  const ActionsState();

  @override
  List<Object?> get props => [];
}

class ActionsInitial extends ActionsState {}

class ActionsLoaded extends ActionsState {
  final List<ExerciseAction> actions;

  const ActionsLoaded({
    required this.actions,
  });

  @override
  List<Object?> get props => [actions];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionsLoaded &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(actions, other.actions);

  @override
  int get hashCode => const DeepCollectionEquality().hash(actions);
}


