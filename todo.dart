import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Task {
  String task;
  bool isCompleted;
  String firebaseId;

  Task({required this.task, this.isCompleted = false, this.firebaseId = ""});

  Map<String, dynamic> toJson() {
    return {'task': task, 'isCompleted': isCompleted};
  }
}

class ToDoListPage extends StatefulWidget {
  final DateTime selectedDate;

  ToDoListPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  DatabaseReference database = FirebaseDatabase.instance.ref("/calendar");

  void _toggleTaskCompletion(String date, String id, bool value) {
    database.child("/${date}/${id}").update({"isCompleted": !value});
  }

  void _deleteTask(String date, String id) {
    database.child("/${date}/${id}").remove();
  }

  void _editTask(BuildContext content, String date, String id) {
    String newTask = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Tarefa"),
          content: TextField(
            onChanged: (value) => {newTask = value},
            decoration: InputDecoration(
              hintText: 'To-Do',
              hintStyle: TextStyle(color: Colors.black45),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  database.child("/${date}/${id}").update({"task": newTask});
                });
                Navigator.pop(context);
              },
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, String date) async {
    String newTask = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          content: TextField(
            onChanged: (value) => {newTask = value},
            decoration: InputDecoration(
              hintText: 'To-Do',
              hintStyle: TextStyle(color: Colors.black45),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  setState(() {
                    final jsonTask = Task(task: newTask).toJson();

                    database.child('/${date}/').push().set(jsonTask);
                  });

                  Navigator.pop(context);
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "To-Do List - ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("/calendar/${date}")
            .orderByChild("task")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No tasks found"));
          }

          final data = snapshot.data!.snapshot;

          final List<Task> taskList = data.children.map((e) {
            final task = e.child("task").value as String;
            final isCompleted = e.child("isCompleted").value as bool;
            final firebaseId = e.key as String;

            return Task(
              task: task,
              isCompleted: isCompleted,
              firebaseId: firebaseId,
            );
          }).toList();

          List<Task> tasks = taskList;

          tasks.sort(
            (a, b) =>
                (a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1)),
          );

          if (taskList.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          tasks[index].task,
                          style: TextStyle(
                            decoration: tasks[index].isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        leading: Checkbox(
                          tristate: false,
                          value: tasks[index].isCompleted,
                          onChanged: (_) {
                            _toggleTaskCompletion(
                              date,
                              tasks[index].firebaseId,
                              tasks[index].isCompleted,
                            );
                          },
                          activeColor: Colors.green[500],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editTask(
                                  context,
                                  date,
                                  tasks[index].firebaseId,
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _deleteTask(date, tasks[index].firebaseId);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("No tasks found"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, date);
        },

        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        child: Icon(Icons.add),
      ),
    );
  }
}
