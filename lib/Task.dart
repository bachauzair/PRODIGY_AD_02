import 'dart:convert';

// Model representing a task
class Task {
  String title;
  bool completed;
  DateTime? dueDate; // Add due date field

  Task({required this.title, this.completed = false, this.dueDate});

  // Convert Task to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'dueDate': dueDate?.millisecondsSinceEpoch, // Convert due date to milliseconds since epoch
    };
  }

  // Convert Map to Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      completed: map['completed'],
      dueDate: map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : null, // Convert milliseconds since epoch to DateTime
    );
  }
}
