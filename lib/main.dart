import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() {
  runApp(const MyApp());
}

// Task class
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

// Main screen
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initHive();
  }

  // Initialize Hive
  void initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('taskBox');
    setState(() {
      loadTasks();
    });
  }

  // Add task
  void addTask(String title) {
    if (title.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: title));
        saveTask(title, false);
      });
      taskController.clear();
      Navigator.of(context).pop();
    }
  }

  // Load tasks from Hive box
  void loadTasks() {
    final taskBox = Hive.box('taskBox');
    for (var i = 0; i < taskBox.length; i++) {
      final task = taskBox.getAt(i);
      tasks.add(Task(title: task[0], isCompleted: task[1]));
    }
  }

  // Toggle checkbox value
  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      Hive.box("taskBox")
          .putAt(index, [tasks[index].title, tasks[index].isCompleted]);
    });
  }

  // Delete task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      Hive.box("taskBox").deleteAt(index);
    });
  }

  // Save task to Hive box
  void saveTask(String title, bool isCompleted) {
    Hive.box('taskBox').add([title, isCompleted]);
  }

  void showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(36, 41, 62, 1),
          // Dialog box header
          title: const Text(
            "Add Task",
            style: TextStyle(
              color: Color.fromRGBO(244, 245, 252, 1),
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          // Task name user input
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
              // Dialog cancel button
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(244, 245, 255, 1),
                ),
              ),
            ),
            // Dialog add task button
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
      // Show add task dialog
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
            // Task builder
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                // Task template
                return Card(
                  color: const Color.fromRGBO(36, 41, 62, 1),
                  surfaceTintColor: const Color.fromRGBO(204, 204, 204, 1),
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    // Task checkbox
                    leading: Checkbox(
                      side: const BorderSide(
                        color: Color.fromRGBO(244, 245, 252, 1),
                      ),
                      checkColor: const Color.fromRGBO(244, 245, 252, 1),
                      activeColor: const Color.fromRGBO(142, 187, 255, 1),
                      value: tasks[index].isCompleted,
                      onChanged: (value) => toggleTask(index),
                    ),
                    // Task name
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
                    // Delete task button
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
