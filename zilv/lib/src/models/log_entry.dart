class LogEntry {
  final int id;
  final int behaviorId;
  final DateTime timestamp;
  final int points;

  LogEntry({
    this.id = 0,
    required this.behaviorId,
    required this.timestamp,
    required this.points,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'behavior_id': behaviorId,
      'timestamp': timestamp.toIso8601String(),
      'points': points,
    };
    if (id > 0) {
      map['id'] = id;
    }
    return map;
  }
}
