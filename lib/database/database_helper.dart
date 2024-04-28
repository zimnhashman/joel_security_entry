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
      version: 8,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $checkInsTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentID TEXT,
            name TEXT,
            grade TEXT,
            checkInTime TEXT,
            date TEXT,
            UNIQUE(studentID, checkInTime) ON CONFLICT REPLACE
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
  // static Future<void> insertCheckIn(Map<String, dynamic> checkInData) async {
  //   Database db = await database;
  //   try {
  //     await db.insert(checkInsTableName, checkInData);
  //   } catch (e) {
  //     print('Duplicate insertion detected: $e');
  //   }
  // }


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

  // Updated insertCheckIn method for handling multiple check-ins for the same student
  static Future<void> insertMultipleCheckIns(List<Map<String, dynamic>> checkInsData) async {
    Database db = await database;
    Batch batch = db.batch();
    for (var checkInData in checkInsData) {
      batch.insert(checkInsTableName, checkInData);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> insertCheckIn(Map<String, dynamic> checkInData) async {
    Database db = await database;
    try {
      await db.insert(checkInsTableName, checkInData);
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        // Handle the UNIQUE constraint violation (duplicate insertion)
        print('Duplicate insertion detected: $e');

        // Update the existing record with the same studentID and checkInTime
        await db.update(
          checkInsTableName,
          checkInData,
          where: 'studentID = ? AND checkInTime = ?',
          whereArgs: [checkInData['studentID'], checkInData['checkInTime']],
        );

        print('Existing record updated.');
      } else {
        // Handle other database exceptions
        print('Error inserting check-in: $e');
      }
    }
  }

}
