import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'students';
  static final _checkInsTable = 'checkins';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'students_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            qrCode TEXT UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE $_checkInsTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId INTEGER,
            checkInTime TEXT,
            FOREIGN KEY (studentId) REFERENCES $_tableName(id)
          )
        ''');
      },
    );
  }

  static Future<void> insertStudent(Map<String, dynamic> student) async {
    final Database db = await database;
    await db.insert(
      _tableName,
      student,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> logCheckIn(int studentId, String checkInTime) async {
    final Database db = await database;
    await db.insert(
      _checkInsTable,
      {'studentId': studentId, 'checkInTime': checkInTime},
    );
  }

  static Future<Map<String, dynamic>?> getStudentByQRCode(String qrCode) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'qrCode = ?',
      whereArgs: [qrCode],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
