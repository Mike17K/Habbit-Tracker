import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habbittracker/bloc/actions_bloc.dart';
import 'package:habbittracker/services/crud/local_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LocalDatabaseService localDatabaseService = LocalDatabaseService();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Clear my data',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                      height: 20), 
                  if (_isDeleting) const SizedBox(
                        height: 30,child: Center(child: CircularProgressIndicator())),
                  if (!_isDeleting) SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Add your logic to clear data here
                            setState(() {
                              _isDeleting = true;
                            });
                            localDatabaseService.clearDatabase().then((value) {
                                  setState(() {
                                    _isDeleting = false;
                                  });
                                  BlocProvider.of<ActionsBloc>(context).add(ActionsEventsDeleted());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Data cleared successfully'),
                                    ),
                                  );
                                }).catchError((error) {
                                  print(error);
                              setState(() {
                                _isDeleting = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error clearing data'),
                                ),
                              );
                            });
                          },
                        child: const Text('Clear All Data'),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
