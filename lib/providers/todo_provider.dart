import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos.reversed.toList();

  Future<void> fetchTodos() async {
    _todos = await _todoService.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    Todo newTodo = Todo(title: title);
    await _todoService.addTodo(newTodo);
    await fetchTodos();
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    todo.isDone = !todo.isDone;
    await _todoService.update(todo);
    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    await _todoService.delete(id);
    await fetchTodos();
  }
}