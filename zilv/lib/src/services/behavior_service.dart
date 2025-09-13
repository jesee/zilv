import 'package:zilv/src/models/log_entry.dart';
import 'package:zilv/src/services/database_helper.dart';

import '../models/behavior.dart';

/// Abstract interface for managing user behaviors and their logs.
abstract class BehaviorService {
  /// Retrieves all behaviors.
  Future<List<Behavior>> getBehaviors();

  /// Adds a new behavior.
  Future<void> addBehavior(Behavior behavior);

  /// Updates an existing behavior.
  Future<void> updateBehavior(Behavior behavior);

  /// Deletes a behavior by its ID.
  Future<void> deleteBehavior(int id);

  /// Logs an occurrence of a behavior.
  Future<void> logBehavior(Behavior behavior);

  /// Retrieves all log entries, sorted by timestamp.
  Future<List<LogEntry>> getLogEntries();

  /// Calculates the user's current total score from all log entries.
  Future<int> getCurrentScore();
}

/// Concrete implementation of [BehaviorService] using SQLite.
class BehaviorServiceImpl implements BehaviorService {
  final DatabaseHelper _dbHelper;

  BehaviorServiceImpl(this._dbHelper);

  @override
  Future<void> addBehavior(Behavior behavior) async {
    final db = await _dbHelper.database;
    await db.insert('behaviors', behavior.toMap());
  }

  @override
  Future<void> deleteBehavior(int id) async {
    final db = await _dbHelper.database;
    await db.delete('behaviors', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Behavior>> getBehaviors() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('behaviors');
    return List.generate(maps.length, (i) {
      return Behavior(
        id: maps[i]['id'],
        name: maps[i]['name'],
        points: maps[i]['points'],
        category: maps[i]['category'],
      );
    });
  }

  @override
  Future<int> getCurrentScore() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(points) as score FROM log_entries',
    );
    return (result.first['score'] as int?) ?? 0;
  }

  @override
  Future<List<LogEntry>> getLogEntries() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'log_entries',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return LogEntry(
        id: maps[i]['id'],
        behaviorId: maps[i]['behavior_id'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
        points: maps[i]['points'],
      );
    });
  }

  @override
  Future<void> logBehavior(Behavior behavior) async {
    final db = await _dbHelper.database;
    final logEntry = LogEntry(
      behaviorId: behavior.id,
      timestamp: DateTime.now(),
      points: behavior.points,
    );
    await db.insert('log_entries', logEntry.toMap());
  }

  @override
  Future<void> updateBehavior(Behavior behavior) async {
    final db = await _dbHelper.database;
    await db.update(
      'behaviors',
      behavior.toMap(),
      where: 'id = ?',
      whereArgs: [behavior.id],
    );
  }
}
