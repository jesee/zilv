import 'package:flutter/material.dart';
import 'package:zilv/src/ui/settings/manage_reminders_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Manage Reminders'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ManageRemindersScreen(),
                ),
              );
            },
          ),
          // Add other settings here
        ],
      ),
    );
  }
}
