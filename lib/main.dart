import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/providers/todo_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider()..fetchTodos(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List', 
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: TextField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a task',
                  prefixIcon: Icon(Icons.task),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 11, 117, 247), width: 1.5)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 11, 117, 247), width: 2)
                  ),
                ),
                onSubmitted: (value) {
                  if (_titleController.text.isEmpty) return;
                  todoProvider.addTodo(_titleController.text);
                  _titleController.clear();
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todoProvider.todos[index];

                  return Card(
                    elevation: 4,
                    color: todo.isDone ? Colors.green : Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: todo.isDone,
                          onChanged:
                              (value) => todoProvider.toggleTodoStatus(todo),
                        ),
                        Expanded(
                          child: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => todoProvider.deleteTodo(todo.id!),
                          icon: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
