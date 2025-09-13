import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilv/src/models/reminder.dart';
import 'package:zilv/src/services/reminder_service.dart';

class ManageRemindersScreen extends StatefulWidget {
  const ManageRemindersScreen({super.key});

  @override
  State<ManageRemindersScreen> createState() => _ManageRemindersScreenState();
}

class _ManageRemindersScreenState extends State<ManageRemindersScreen> {
  late Future<List<Reminder>> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    final reminderService = Provider.of<ReminderService>(
      context,
      listen: false,
    );
    setState(() {
      _remindersFuture = reminderService.getReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Reminders')),
      body: FutureBuilder<List<Reminder>>(
        future: _remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading reminders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reminders yet.'));
          }

          final reminders = snapshot.data!;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(reminder.time),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteReminder(reminder.id),
                ),
                onTap: () => _showReminderDialog(reminder: reminder),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteReminder(int id) async {
    final reminderService = Provider.of<ReminderService>(
      context,
      listen: false,
    );
    await reminderService.deleteReminder(id);
    _loadReminders();
  }

  void _showReminderDialog({Reminder? reminder}) {
    final titleController = TextEditingController(text: reminder?.title ?? '');
    final bodyController = TextEditingController(text: reminder?.body ?? '');
    final timeController = TextEditingController(text: reminder?.time ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reminder == null ? 'Add Reminder' : 'Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text;
                final body = bodyController.text;
                final time = timeController.text;
                final reminderService = Provider.of<ReminderService>(
                  context,
                  listen: false,
                );

                if (reminder == null) {
                  await reminderService.addReminder(
                    Reminder(id: 0, title: title, body: body, time: time),
                  );
                } else {
                  await reminderService.updateReminder(
                    Reminder(
                      id: reminder.id,
                      title: title,
                      body: body,
                      time: time,
                    ),
                  );
                }
                _loadReminders();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
