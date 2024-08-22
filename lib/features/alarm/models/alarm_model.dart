class Alarm {
  int id;
  DateTime time;
  String label;

  Alarm({required this.id, required this.time, required this.label});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'label': label,
    };
  }

  static Alarm fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'],
      time: DateTime.parse(map['time']),
      label: map['label'],
    );
  }
}
