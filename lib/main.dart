import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'TODOListScreen.dart';
import 'Task Manager.dart';
import 'Task.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO List',
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: Provider.of<TaskManager>(context).isDarkMode ? ThemeMode.dark : ThemeMode.light, // Set initial theme mode based on TaskManager
      home: TODOListScreen(),
    );
  }
}
























