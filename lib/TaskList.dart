import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'Task Manager.dart';
import 'Task.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              Provider.of<TaskManager>(context, listen: false).searchQuery = value;
            },
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<TaskManager>(
            builder: (context, taskManager, child) {
              final List<Task> filteredTasks = taskManager.tasks
                  .where((task) =>
                  task.title.toLowerCase().contains(taskManager.searchQuery.toLowerCase()))
                  .toList();

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Dismissible(
                    key: Key(task.title),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      Provider.of<TaskManager>(context, listen: false).deleteTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task "${task.title}" deleted.'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              Provider.of<TaskManager>(context, listen: false).addTask(task.title, dueDate: task.dueDate);
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        subtitle: task.dueDate != null
                            ? Text(
                          'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editTask(context, taskManager, task, index);
                              },
                            ),
                            Checkbox(
                              value: task.completed,
                              onChanged: (bool? value) {
                                Provider.of<TaskManager>(context, listen: false).toggleTaskCompletion(index);
                                _showUndoSnackbar(context, taskManager, task);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to show snackbar for undoing task completion
  void _showUndoSnackbar(BuildContext context, TaskManager taskManager, Task task) {
    final snackBar = SnackBar(
      content: Text('Task completed.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          taskManager.toggleTaskCompletion(taskManager.tasks.indexOf(task));
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to show dialog for editing a task
  void _editTask(BuildContext context, TaskManager taskManager, Task task, int index) {
    String newTitle = task.title;
    DateTime? newDueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: TextEditingController(text: newTitle),
                onChanged: (value) {
                  newTitle = value;
                },
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
                          initialDate: newDueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          newDueDate = selectedDate;
                        }
                      },
                      child: Text(
                        newDueDate != null
                            ? DateFormat('yyyy-MM-dd').format(newDueDate!)
                            : 'Select Date',
                        style: TextStyle(
                          color: newDueDate != null ? Theme.of(context).textTheme.bodyText1!.color : Colors.grey,
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
                if (newTitle.isNotEmpty) {
                  Provider.of<TaskManager>(context, listen: false).editTask(index, newTitle, newDueDate);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
