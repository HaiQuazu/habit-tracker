import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('habit_tracker.db');

    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL,
        repeatDays TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        currentStreak INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertHabit(
    Map<String, dynamic> habit,
  ) async {
    final db = await database;

    return await db.insert(
      'habits',
      habit,
    );
  }

  // READ
  Future<List<Map<String, dynamic>>> getHabits() async {
    final db = await database;

    return await db.query(
      'habits',
      orderBy: 'id DESC',
    );
  }

  // UPDATE
  Future<int> updateHabit(
    int id,
    Map<String, dynamic> habit,
  ) async {
    final db = await database;

    return await db.update(
      'habits',
      habit,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteHabit(int id) async {
    final db = await database;

    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;

    await db.close();

    _database = null;
  }
}
