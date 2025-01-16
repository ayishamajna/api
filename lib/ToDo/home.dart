import 'package:flutter/material.dart';
import 'package:todo_api/ToDo/services/ToDo.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> duties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : duties.isEmpty
              ? const Center(
                  child: Text(
                    'No data found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: duties.length,
                  itemBuilder: (context, index) {
                    final work = duties[index];
                    return Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              work['title'] ?? 'No Title',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(work['description'] ?? 'No Description'),
                          ],
                        ),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            onPressed: () {
                              showAlertDialogueBox(work['id']);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              editTodo(work['id'], work['title'],
                                  work['description']);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 249, 104, 94),
        onPressed: addTodoDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void addTodoDialog() {
    titleController.clear();
    descriptionController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              addTodo();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editTodo(String id, String initialTitle, String initialDescription) {
    titleController.text = initialTitle;
    descriptionController.text = initialDescription;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              updateTodo(id, titleController.text, descriptionController.text);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void showAlertDialogueBox(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTodo(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> loadTodos() async {
    try {
      final response = await TodoServices.getTodos();
      setState(() {
        duties = response;
        isLoading = false;
      });
    } catch (e) {
      showError('Failed to load tasks');
    }
  }

  Future<void> addTodo() async {
    try {
      await TodoServices.createTodo(
        titleController.text,
        descriptionController.text,
      );
      titleController.clear();
      descriptionController.clear();
      await loadTodos();
    } catch (e) {
      showError('Failed to add task');
    }
  }

  Future<void> updateTodo(String id, String title, String desc) async {
    try {
      await TodoServices.updatetodo(id, title, desc);
      await loadTodos();
    } catch (e) {
      showError('Failed to update task');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await TodoServices.deleteTodo(id);
      await loadTodos();
    } catch (e) {
      showError('Failed to delete task');
    }
  }
}
