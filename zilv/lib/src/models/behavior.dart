class Behavior {
  final int id;
  String name;
  int points; // Positive for good habits, negative for bad ones
  String category;

  Behavior({
    required this.id,
    required this.name,
    required this.points,
    this.category = 'General',
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'points': points, 'category': category};
  }
}
