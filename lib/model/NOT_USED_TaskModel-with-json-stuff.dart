import 'dart:convert';

Task taskFromJson(String str) {
  final jsonData = json.decode(str);
  return Task.fromMap(jsonData);
}

String taskToJson(Task data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Task {
  final int id;
  final String label;
  final int done;

  Task({this.id, this.label, this.done});

  factory Task.fromMap(Map<String, dynamic> json) => new Task(
        id: json["id"],
        label: json["label"],
        done: json["done"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "label": label,
        "done": done,
      };

}
