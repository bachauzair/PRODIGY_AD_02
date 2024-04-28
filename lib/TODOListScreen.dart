import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'Task Manager.dart';
import 'TaskList.dart';
import 'main.dart';

class TODOListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<TaskManager>(context, listen: false).toggleThemeMode();
            },
          ),
        ],
      ),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to show dialog for adding a new task
  void _showTaskDialog(BuildContext context) {
    String taskTitle = '';
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                onChanged: (value) {
                  taskTitle = value;
                },
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Due Date: '),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          dueDate = selectedDate;
                        }
                      },
                      child: Text(
                        dueDate != null
                            ? DateFormat('yyyy-MM-dd').format(dueDate!)
                            : 'Select Date',
                        style: TextStyle(
                          color: dueDate != null
                              ? Theme.of(context).textTheme.bodyText1!.color
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  Provider.of<TaskManager>(context, listen: false)
                      .addTask(taskTitle, dueDate: dueDate); // Pass 'dueDate' with its name
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

}