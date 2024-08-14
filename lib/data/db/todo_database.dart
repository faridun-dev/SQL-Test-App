import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_test_app/data/models/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";

    await db.execute(
      """
      CREATE TABLE $tableTodo (
        ${TodoFields.id} $idType,
        ${TodoFields.title} $textType,
        ${TodoFields.description} $textType,
        ${TodoFields.createdTime} $textType
      )
    """,
    );
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;

    final id = await db.insert(tableTodo, todo.toJson());

    return todo.copy(id: id);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTodo,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found!");
    }
  }

  Future<List<Todo>> readAllTodo() async {
    final db = await instance.database;

    final result = await db.query(tableTodo);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;

    return db.update(
      tableTodo,
      todo.toJson(),
      where: "${TodoFields.id} = ?",
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTodo,
      where: "${TodoFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
