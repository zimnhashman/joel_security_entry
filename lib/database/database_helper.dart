import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final String checkInsTableName = 'check_ins';
  static final String studentsTableName = 'students';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'security_database.db');
    print('Database path: $path');

    // Open the database. Create if it doesn't exist
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $checkInsTableName(
            studentID TEXT PRIMARY KEY,
            grade TEXT,
            checkInTime TEXT,
            date TEXT
          )
          ''',
        );
        await db.execute(
          '''
          CREATE TABLE $studentsTableName(
            studentID TEXT PRIMARY KEY,
            name TEXT,
            grade TEXT,
            isCheckInDisabled INTEGER
          )
          ''',
        );
        // Add some initial data if needed
        await db.insert(studentsTableName, {
          'studentID': '12345',
          'name': 'John Doe',
          'grade': 'Grade 10',
          'isCheckInDisabled': 0,
        });
      },
    );
  }

  // CRUD operations for students
  static Future<Map<String, dynamic>?> getStudentById(String studentID) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      studentsTableName,
      where: 'studentID = ?',
      whereArgs: [studentID],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<void> insertStudent(Map<String, dynamic> studentData) async {
    Database db = await database;
    await db.insert(studentsTableName, studentData);
  }

  static Future<void> updateStudent(Map<String, dynamic> studentData) async {
    Database db = await database;
    await db.update(
      studentsTableName,
      studentData,
      where: 'studentID = ?',
      whereArgs: [studentData['studentID']],
    );
  }

  static Future<void> deleteStudent(String studentID) async {
    Database db = await database;
    await db.delete(
      studentsTableName,
      where: 'studentID = ?',
      whereArgs: [studentID],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllStudents() async {
    Database db = await database;
    return db.query(studentsTableName);
  }

  // CRUD operations for check-ins
  static Future<void> insertCheckIn(Map<String, dynamic> checkInData) async {
    Database db = await database;
    await db.insert(checkInsTableName, checkInData);
  }

  static Future<List<Map<String, dynamic>>> getAllCheckIns() async {
    Database db = await database;
    return db.query(checkInsTableName);
  }

  static Future<void> updateCheckIn(Map<String, dynamic> checkInData) async {
    Database db = await database;
    await db.update(
      checkInsTableName,
      checkInData,
      where: 'studentID = ?',
      whereArgs: [checkInData['studentID']],
    );
  }

  static Future<void> deleteCheckIn(String studentID) async {
    Database db = await database;
    await db.delete(
      checkInsTableName,
      where: 'studentID = ?',
      whereArgs: [studentID],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllClockInRecords() async {
    Database db = await database;
    return db.query(checkInsTableName);
  }
}
