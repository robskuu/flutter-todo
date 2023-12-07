import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  void addTask(String title) {
    if (title.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: title));
      });
      taskController.clear();
      Navigator.of(context).pop();
    }
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(36, 41, 62, 1),
          title: const Text(
            "Add Task",
            style: TextStyle(
              color: Color.fromRGBO(244, 245, 252, 1),
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: TextField(
            style: const TextStyle(
              color: Color.fromRGBO(244, 245, 252, 1),
            ),
            cursorColor: const Color.fromRGBO(244, 245, 252, 1),
            autofocus: true,
            controller: taskController,
            decoration: const InputDecoration(
              labelText: 'Enter task',
              labelStyle: TextStyle(
                color: Color.fromRGBO(244, 245, 252, 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                taskController.clear();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(244, 245, 255, 1),
                ),
              ),
            ),
            TextButton(
              onPressed: () => addTask(taskController.text),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Color.fromRGBO(244, 245, 255, 1),
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 41, 62, 1),
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Color.fromRGBO(244, 245, 252, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(142, 187, 255, 1),
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(244, 245, 252, 1),
        ),
      ),
      body: Column(
        children: [
          const Divider(
            color: Color.fromRGBO(142, 187, 255, 1),
            thickness: 4.0,
            height: 20.0,
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromRGBO(36, 41, 62, 1),
                  surfaceTintColor: const Color.fromRGBO(204, 204, 204, 1),
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Checkbox(
                      side: const BorderSide(
                        color: Color.fromRGBO(244, 245, 252, 1),
                      ),
                      checkColor: const Color.fromRGBO(244, 245, 252, 1),
                      activeColor: const Color.fromRGBO(142, 187, 255, 1),
                      value: tasks[index].isCompleted,
                      onChanged: (value) => toggleTask(index),
                    ),
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        color: const Color.fromRGBO(244, 245, 252, 1),
                        decoration: tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: const Color.fromRGBO(244, 245, 252, 1),
                        decorationThickness: 2.0,
                      ),
                    ),
                    trailing: tasks[index].isCompleted
                        ? IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromRGBO(142, 187, 255, 1),
                            ),
                            onPressed: () => deleteTask(index),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
