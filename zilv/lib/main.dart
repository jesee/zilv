import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilv/src/services/behavior_service.dart';
import 'package:zilv/src/services/database_helper.dart';
import 'package:zilv/src/services/reminder_service.dart';
import 'package:zilv/src/ui/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final reminderService = ReminderServiceImpl(DatabaseHelper());
  await reminderService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),
        ProxyProvider<DatabaseHelper, BehaviorService>(
          update: (_, dbHelper, __) => BehaviorServiceImpl(dbHelper),
        ),
        ProxyProvider<DatabaseHelper, ReminderService>(
          update: (_, dbHelper, __) => ReminderServiceImpl(dbHelper),
        ),
      ],
      child: MaterialApp(
        title: 'Zilv Self-Discipline',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
