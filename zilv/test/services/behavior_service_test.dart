import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:zilv/src/models/behavior.dart';
import 'package:zilv/src/services/behavior_service.dart';
import 'package:zilv/src/services/database_helper.dart';

void main() {
  late BehaviorService behaviorService;
  late DatabaseHelper databaseHelper;

  // Initialize FFI for sqflite
  sqfliteFfiInit();

  setUp(() async {
    // Use an in-memory database for testing
    databaseFactory = databaseFactoryFfi;
    databaseHelper = DatabaseHelper();
    behaviorService = BehaviorServiceImpl(databaseHelper);

    // Make sure the table is created
    final db = await databaseHelper.database;
    await db.execute('DELETE FROM behaviors');
    await db.execute('DELETE FROM log_entries');
  });

  test('addBehavior and getBehaviors', () async {
    // Arrange
    final behavior = Behavior(id: 1, name: 'Read a book', points: 10);

    // Act
    await behaviorService.addBehavior(behavior);
    final behaviors = await behaviorService.getBehaviors();

    // Assert
    expect(behaviors.length, 1);
    expect(behaviors.first.name, 'Read a book');
  });

  test('updateBehavior', () async {
    // Arrange
    final behavior = Behavior(id: 1, name: 'Workout', points: 20);
    await behaviorService.addBehavior(behavior);

    // Act
    final updatedBehavior = Behavior(
      id: 1,
      name: 'Intense Workout',
      points: 25,
    );
    await behaviorService.updateBehavior(updatedBehavior);
    final behaviors = await behaviorService.getBehaviors();

    // Assert
    expect(behaviors.first.name, 'Intense Workout');
    expect(behaviors.first.points, 25);
  });

  test('deleteBehavior', () async {
    // Arrange
    final behavior = Behavior(id: 1, name: 'Meditate', points: 5);
    await behaviorService.addBehavior(behavior);

    // Act
    await behaviorService.deleteBehavior(1);
    final behaviors = await behaviorService.getBehaviors();

    // Assert
    expect(behaviors.isEmpty, isTrue);
  });

  test('logBehavior and getCurrentScore', () async {
    // Arrange
    final goodBehavior = Behavior(id: 1, name: 'Eat Healthy', points: 10);
    final badBehavior = Behavior(id: 2, name: 'Eat Junk Food', points: -5);
    await behaviorService.addBehavior(goodBehavior);
    await behaviorService.addBehavior(badBehavior);

    // Act
    await behaviorService.logBehavior(goodBehavior);
    await behaviorService.logBehavior(badBehavior);
    await behaviorService.logBehavior(goodBehavior);

    // Assert
    final score = await behaviorService.getCurrentScore();
    expect(score, 15); // 10 - 5 + 10
  });

  test('getLogEntries', () async {
    // Arrange
    final behavior = Behavior(id: 1, name: 'Study', points: 15);
    await behaviorService.addBehavior(behavior);
    await behaviorService.logBehavior(behavior);
    await Future.delayed(
      const Duration(milliseconds: 10),
    ); // ensure different timestamps
    await behaviorService.logBehavior(behavior);

    // Act
    final logs = await behaviorService.getLogEntries();

    // Assert
    expect(logs.length, 2);
    expect(logs.first.timestamp.isAfter(logs.last.timestamp), isTrue);
  });
}
