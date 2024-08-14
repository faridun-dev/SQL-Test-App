import 'package:flutter/material.dart';
import 'package:sql_test_app/data/db/todo_database.dart';
import 'package:sql_test_app/data/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<Todo> todos = [];

  Future refreshTodos() async {
    todos = await TodoDatabase.instance.readAllTodo();
    setState(() {});
  }

  Future createTodo(
      String title, String description, DateTime createdTime) async {
    Todo todo = Todo(
      title: title,
      description: description,
      createdTime: createdTime,
    );
    await TodoDatabase.instance.create(todo);
    refreshTodos();
    _titleController.clear();
    _descriptionController.clear();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    refreshTodos();
  }

  @override
  void dispose() {
    TodoDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Add todo",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                  ),
                  TextField(
                    controller: _descriptionController,
                  ),
                  TextButton(
                    onPressed: () {
                      createTodo(
                        _titleController.text,
                        _descriptionController.text,
                        DateTime.now(),
                      );
                    },
                    child: const Text(
                      "ADD",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 12,
              right: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    todos[index].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    todos[index].description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
