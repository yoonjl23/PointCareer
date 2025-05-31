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
            studentId TEXT PRIMARY KEY,
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
      where: 'studentId = ? AND password = ?',
      whereArgs: [studentId, password],
    );
    return result.isNotEmpty;
  }

  Future<void> debugPrintAllUsers() async {
    final db = await database;
    final users = await db.query('users');
    for (var user in users) {
      print('📋 ${user['studentId']} / ${user['password']}');
    }
  }
}
