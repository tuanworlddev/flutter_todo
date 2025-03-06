import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/todo.dart';

class TodoService {
  Database? _database;
  final String tableName = 'todos';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((e) => Todo.fromMap(e)).toList();
  }

  Future<int> addTodo(Todo todo) async {
    final db = await database;
    return await db.insert(tableName, todo.toMap());
  }

  Future<int> update(Todo todo) async {
    final db = await database;
    return await db.update(tableName, todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}