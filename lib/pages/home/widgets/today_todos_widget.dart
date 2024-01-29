import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habbittracker/bloc/actions_bloc.dart';
import 'package:habbittracker/models/action_model.dart';

class TodayTodosWidget extends StatefulWidget {
  const TodayTodosWidget({Key? key}) : super(key: key);

  @override
  State<TodayTodosWidget> createState() => _TodayTodosWidgetState();
}

class _TodayTodosWidgetState extends State<TodayTodosWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Σήμερα',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 8),
        BlocBuilder<ActionsBloc, ActionsState>(
          builder: (context, state) {
            if (state is ActionsInitial) {
              return const _LoadingStateWidget();
            } else if (state is ActionsLoaded) {
              return _LoadedStateWidget(
                  actions: state.actions,
                  actionNumberToday: state.actions.where((element) => element.id == 0 && element.date.year == DateTime.now().year && element.date.month == DateTime.now().month && element.date.day == DateTime.now().day).toList().length,
                  id: 0,
                  name: 'Ποδοκνημική Μπάλα',
                  textOnCheckbox: '5\'');
            } else {
              return const _ErrorStateWidget();
            }
          },
        ),
        BlocBuilder<ActionsBloc, ActionsState>(
          builder: (context, state) {
            if (state is ActionsInitial) {
              return const _LoadingStateWidget();
            } else if (state is ActionsLoaded) {
              return _LoadedStateWidget(
                  actions: state.actions,
                  actionNumberToday: state.actions.where((element) => element.id == 1 && element.date.year == DateTime.now().year && element.date.month == DateTime.now().month && element.date.day == DateTime.now().day).toList().length,
                  id: 1,
                  name: 'Παγοθεραπεία',
                  textOnCheckbox: '10\'');
            } else {
              return const _ErrorStateWidget();
            }
          },
        ),
      ],
    );
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 45,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _LoadedStateWidget extends StatefulWidget {
  final List<ExerciseAction> actions;
  final int actionNumberToday;
  final int id;
  final String name;
  final String textOnCheckbox;

  const _LoadedStateWidget({
    Key? key,
    required this.actions,
    required this.actionNumberToday,
    required this.id,
    required this.name,
    required this.textOnCheckbox,
  }) : super(key: key);

  @override
  State<_LoadedStateWidget> createState() => _LoadedStateWidgetState();
}

class _LoadedStateWidgetState extends State<_LoadedStateWidget> {  
  List<bool> checked = List.generate(3, (index) => false);

  @override
  Widget build(BuildContext context) {
    checked = List.generate(3, (index) => index < widget.actionNumberToday);
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.name, style: const TextStyle(fontSize: 12)),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                customCheckbox(widget.textOnCheckbox, checked[i], (value) {
                  if (value == false) {
                    BlocProvider.of<ActionsBloc>(context).add(
                      ActionsTodayEventDelete(
                        action:
                            ExerciseAction(id: widget.id, date: DateTime.now()),
                      ),
                    );
                  } else {
                    BlocProvider.of<ActionsBloc>(context).add(
                      ActionsTodayEventAdd(
                        action:
                            ExerciseAction(id: widget.id, date: DateTime.now()),
                      ),
                    );
                  }

                  setState(() {
                    checked[i] = value!;
                  });
                }),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  const _ErrorStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 45,
      child: Center(child: Text('Error')),
    );
  }
}

Widget customCheckbox(String name, bool value, Function onChanged) {
  if (value == false) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: const Color(0xFF3D3D24),
            width: 1.0,
          ),
        ),
        child: Center(child: Text(name, style: const TextStyle(fontSize: 12))),
      ),
    );
  }

  return Row(children: [
    const SizedBox(width: 6),
    SizedBox(
      width: 35,
      height: 35,
      child: IconButton(
        onPressed: () {
          onChanged(!value);
        },
        icon: const Icon(Icons.check, color: Colors.green),
      ),
    ),
  ]);
}
