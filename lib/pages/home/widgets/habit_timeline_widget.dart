import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habbittracker/bloc/actions_bloc.dart';
import 'package:habbittracker/models/action_model.dart';

class HabitTimeLineWidget extends StatefulWidget {
  final int id;
  final String name;

  const HabitTimeLineWidget({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  State<HabitTimeLineWidget> createState() => _HabitTimeLineWidgetState();
}

class _HabitTimeLineWidgetState extends State<HabitTimeLineWidget> {
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: [
          headSection(
              widget.name,
              year,
              () => setState(() => year--),
              () {
                if (year < DateTime.now().year) {
                  setState(() => year++);
                }
              }),
          const SizedBox(height: 0),
          BlocBuilder<ActionsBloc, ActionsState>(builder: (context, state) {
            if (state is ActionsInitial) {
              return const SizedBox(height: 45, child: Center(child: CircularProgressIndicator()));
            } else if (state is ActionsLoaded) {
              return SizedBox(height: 45,child: datesHappentActions(id: widget.id,actions: state.actions, year: year));
            } else {
              return const SizedBox(height: 45, child: Center(child: Text('Error')));
            }
          }),
          const SizedBox(height: 5),
          colorList(),
        ],
      ),
    ]);
  }
}

Widget headSection(
    String name, int year, Function decrementYear, Function incrementYear) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => decrementYear(),
              icon: const Icon(Icons.arrow_back_ios, size: 12)),
          Text(
            year.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (year >= DateTime.now().year) IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[500])
          )
          else IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => incrementYear(),
            icon: const Icon(Icons.arrow_forward_ios, size: 12),            
          ),
        ],
      ),
    ],
  );
}

Widget datesHappentActions({required int id, required List<ExerciseAction> actions, required int year}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(
      52,
      (week) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (day) {
          DateTime currentDate =
              DateTime(year, 1, 1).add(Duration(days: week * 7 + day));
          return Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: intToColor(countOccurrences(actions.where((a) => a.id == id).toList(), currentDate)),
              borderRadius: BorderRadius.circular(1.0), // Border radius
              border: Border.all(
                color: const Color(0xFF3D3D24), // Stroke color
                width: 1, // Stroke width
              ),
            ),
          );
        }),
      ),
    ),
  );
}

int countOccurrences(List<ExerciseAction> actions, DateTime testDate) {
  if(testDate.isAfter(DateTime.now())) {
    return -1;
  }
  return actions.where((a) => a.date.year == testDate.year && a.date.month == testDate.month && a.date.day == testDate.day).length;
}

Color intToColor(int color) {
  switch (color) {
    case 0:
      return const Color(0xFF3D3D24);
    case 1:
      return const Color(0xFFFEFD97);
    case 2:
      return const Color(0xFFFED502);
    case 3:
      return const Color(0xFF4AB818);
    case -1:
      return const Color(0xFFFFFFFF); // this when the date is in the future
    default:
      return const Color(0xFF3D3D24);
  }
}

Widget colorList() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildColorRow('0', const Color(0xFF3D3D24)),
      _buildColorRow('1', const Color(0xFFFEFD97)),
      _buildColorRow('2', const Color(0xFFFED502)),
      _buildColorRow('3', const Color(0xFF4AB818)),
    ],
  );
}

Widget _buildColorRow(String number, Color color) {
  return Row(
    children: [
      Text(number),
      const SizedBox(width: 4),
      Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0), // Border radius
          border: Border.all(
            color: const Color(0xFF3D3D24), // Stroke color
            width: 1, // Stroke width
          ),
        ),
      ),
      const SizedBox(width: 12),
    ],
  );
}
