import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:zilv/src/models/reminder.dart';
import 'package:zilv/src/services/database_helper.dart';
import 'package:zilv/src/services/reminder_service.dart';

void main() {
  late ReminderService reminderService;
  late DatabaseHelper databaseHelper;

  // Initialize FFI for sqflite
  sqfliteFfiInit();

  setUp(() async {
    // Use an in-memory database for testing
    databaseFactory = databaseFactoryFfi;
    databaseHelper = DatabaseHelper();
    reminderService = ReminderServiceImpl(databaseHelper);

    // Make sure the table is created and empty
    final db = await databaseHelper.database;
    await db.execute('DELETE FROM reminders');
  });

  test('addReminder and getReminders', () async {
    // Arrange
    final reminder = Reminder(
      id: 1,
      title: 'Morning Jog',
      body: 'Jog for 30 minutes',
      time: '07:00',
    );

    // Act
    await reminderService.addReminder(reminder);
    final reminders = await reminderService.getReminders();

    // Assert
    expect(reminders.length, 1);
    expect(reminders.first.title, 'Morning Jog');
  });

  test('updateReminder', () async {
    // Arrange
    final reminder = Reminder(
      id: 1,
      title: 'Read',
      body: 'Read a chapter',
      time: '21:00',
    );
    await reminderService.addReminder(reminder);

    // Act
    final updatedReminder = Reminder(
      id: 1,
      title: 'Read More',
      body: 'Read two chapters',
      time: '21:30',
    );
    await reminderService.updateReminder(updatedReminder);
    final reminders = await reminderService.getReminders();

    // Assert
    expect(reminders.first.title, 'Read More');
    expect(reminders.first.time, '21:30');
  });

  test('deleteReminder', () async {
    // Arrange
    final reminder = Reminder(
      id: 1,
      title: 'Drink Water',
      body: 'Drink a glass of water',
      time: '10:00',
    );
    await reminderService.addReminder(reminder);

    // Act
    await reminderService.deleteReminder(1);
    final reminders = await reminderService.getReminders();

    // Assert
    expect(reminders.isEmpty, isTrue);
  });
}
