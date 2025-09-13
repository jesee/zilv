class User {
  final int id;
  final String name;
  int score;

  User({required this.id, required this.name, this.score = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'score': score};
  }
}
