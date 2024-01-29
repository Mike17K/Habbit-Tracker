import 'package:flutter/material.dart';
import 'package:habbittracker/pages/home/widgets/habit_timeline_widget.dart';
import 'package:habbittracker/pages/home/widgets/today_todos_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Προετημασία Μιχαήλ'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ]
       ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            HabitTimeLineWidget(
              id: 0,
              name: "Ποδοκνημική",
            ),
            SizedBox(height: 16),
            HabitTimeLineWidget(
              id: 1,
              name: "Παγοθεραπεία",
            ),
            SizedBox(height: 16),
            TodayTodosWidget(),
          ],
        ),
      ),
    );
  }
}
