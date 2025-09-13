import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'zilv_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE behaviors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        points INTEGER NOT NULL,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE log_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        behavior_id INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        points INTEGER NOT NULL,
        FOREIGN KEY (behavior_id) REFERENCES behaviors (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }
}
