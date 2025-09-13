import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:zilv/src/services/database_helper.dart';

import '../models/reminder.dart';

/// Abstract interface for managing reminders and scheduling notifications.
abstract class ReminderService {
  /// Initializes the notification service.
  Future<void> initialize();

  /// Retrieves all reminders.
  Future<List<Reminder>> getReminders();

  /// Adds a new reminder and schedules a notification.
  Future<void> addReminder(Reminder reminder);

  /// Updates an existing reminder and reschedules its notification.
  Future<void> updateReminder(Reminder reminder);

  /// Deletes a reminder and cancels its notification.
  Future<void> deleteReminder(int id);
}

/// Concrete implementation of [ReminderService] using SQLite and flutter_local_notifications.
class ReminderServiceImpl implements ReminderService {
  final DatabaseHelper _dbHelper;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReminderServiceImpl(this._dbHelper);

  @override
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    int id = await db.insert('reminders', reminder.toMap());
    _scheduleNotification(reminder.copyWith(id: id));
  }

  @override
  Future<void> deleteReminder(int id) async {
    final db = await _dbHelper.database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
    _notificationsPlugin.cancel(id);
  }

  @override
  Future<List<Reminder>> getReminders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        time: maps[i]['time'],
      );
    });
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
    _scheduleNotification(reminder);
  }

  void _scheduleNotification(Reminder reminder) {
    final timeParts = reminder.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    _notificationsPlugin.zonedSchedule(
      reminder.id,
      reminder.title,
      reminder.body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'zilv_reminders',
          'Zilv Reminders',
          channelDescription: 'Reminders for your self-discipline tasks',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

extension ReminderCopyWith on Reminder {
  Reminder copyWith({int? id}) {
    return Reminder(id: id ?? this.id, title: title, body: body, time: time);
  }
}
