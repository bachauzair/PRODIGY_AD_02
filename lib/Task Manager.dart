import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Task.dart';

class TaskManager extends ChangeNotifier {
  List<Task> _tasks = [];
  SharedPreferences? _prefs;
  bool _isDarkMode = false; // Add isDarkMode property
  String _searchQuery = ''; // Add this line
  String get searchQuery => _searchQuery;


  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }


  TaskManager() {
    _initSharedPreferences();
  }

  // Initialize shared preferences
  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTasks();
    _loadThemeMode(); // Load theme mode on initialization
  }

  // Load tasks from shared preferences
  void _loadTasks() {
    final List<String>? tasksJson = _prefs?.getStringList('tasks');
    if (tasksJson != null) {
      _tasks = tasksJson.map((taskJson) => Task.fromMap(jsonDecode(taskJson))).toList();
      notifyListeners();
    }
  }

  // Save tasks to shared preferences
  void _saveTasks() {
    final List<String> tasksJson = _tasks.map((task) => jsonEncode(task.toMap())).toList();
    _prefs?.setStringList('tasks', tasksJson);
  }

  // Load theme mode from shared preferences
  void _loadThemeMode() {
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Save theme mode to shared preferences
  void _saveThemeMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _prefs?.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  // Getter for tasks
  List<Task> get tasks => _tasks;

  // Getter for theme mode
  bool get isDarkMode => _isDarkMode;

  // Add a new task
  void addTask(String title, {DateTime? dueDate}) {
    _tasks.add(Task(title: title, dueDate: dueDate)); // Pass 'dueDate' to Task constructor
    _saveTasks();
    notifyListeners();
  }

  // Edit an existing task
  void editTask(int index, String newTitle, DateTime? dueDate) {
    _tasks[index].title = newTitle;
    _tasks[index].dueDate = dueDate;
    _saveTasks();
    notifyListeners();
  }

  // Delete a task
  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  // Toggle task completion
  void toggleTaskCompletion(int index) {
    _tasks[index].completed = !_tasks[index].completed;
    _saveTasks();
    notifyListeners();
  }

  // Toggle theme mode
  void toggleThemeMode() {
    _saveThemeMode(!_isDarkMode);
  }
}
