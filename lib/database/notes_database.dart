import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

class NotesDatabase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, text TEXT)'
        );
      },
      version:  1,
    );
  }

  Future<void> addTodo(Note todo) async {
    final db = await initializeDB();
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> todos() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('todos');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> deleteTodo(int id) async {
    final db = await initializeDB();
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}