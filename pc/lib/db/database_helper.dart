import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(String studentId, String password) async {
    final db = await database;
    try {
      return await db.insert(
        'users',
        {'studentId': studentId, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      print('Insert failed: $e');
      return -1;
    }
  }

  Future<bool> verifyUser(String studentId, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [studentId, password],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> debugPrintAllUsers() async {
    final users = await getAllUsers();
    for (var user in users) {
      print('📋 User => ${user['studentId']} / ${user['password']}');
    }
  }
}
