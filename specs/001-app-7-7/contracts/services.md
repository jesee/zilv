# Service Contracts

This directory defines the public interfaces for the application's services.

## BehaviorService Contract

Handles CRUD operations for behaviors and logging.

```dart
abstract class BehaviorService {
  /// Retrieves all behaviors.
  Future<List<Behavior>> getBehaviors();

  /// Adds a new behavior.
  Future<void> addBehavior(Behavior behavior);

  /// Updates an existing behavior.
  Future<void> updateBehavior(Behavior behavior);

  /// Deletes a behavior.
  Future<void> deleteBehavior(int behaviorId);

  /// Logs a behavior, updates the user's score, and returns the new score.
  /// Throws an exception if the daily point limit is reached for positive behaviors.
  Future<int> logBehavior(int behaviorId);

  /// Gets the current user's score.
  Future<int> getUserScore();
}
```

## ReminderService Contract

Handles scheduling and managing reminders.

```dart
abstract class ReminderService {
  /// Retrieves the current reminder settings.
  Future<Reminder> getReminder();

  /// Saves and reschedules the reminder based on the provided settings.
  Future<void> saveReminder(Reminder reminder);

  /// Disables all reminders.
  Future<void> disableReminders();
}
```
