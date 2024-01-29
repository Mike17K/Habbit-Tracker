import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habbittracker/bloc/actions_bloc.dart';
import 'package:habbittracker/pages/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ActionsBloc()..add(ActionEventsLoad())),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4AB818), // Light Green
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              // fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: const Color(0xFFEDF8E8), // Light Green
        ),
        home: HomePage(),
      ),
    );
  }
}
