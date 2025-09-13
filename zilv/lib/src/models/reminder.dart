class Reminder {
  final int id;
  final String title;
  final String body;
  final String time; // Stored in HH:mm format

  Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body, 'time': time};
  }
}
