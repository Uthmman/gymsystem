import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gymsystem/model/attendance.dart';
import 'package:gymsystem/model/member.dart';
import 'package:gymsystem/model/payment.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constants.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  static List<Member> members = [];
  static List<Staff> staffs = [];
  static List<Attendance> memberAttendance = [];
  static List<Attendance> staffAttendance = [];
  static List<Payment> payments = [];

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}$dbPath';

    var notesDatabase = await openDatabase(
      path,
      version: 20,
      onCreate: _createDb,
    );
    if (kDebugMode) {
      notesDatabase.getVersion().then((value) {
        print("db is version: ${value}");
        print("db path is: ${notesDatabase.path}");
      });
    }
    return notesDatabase;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  closeDb() async {
    await _database!.close();
  }

  // creating database
  _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${DatabaseConst.member}('
        'rfid INTEGER PRIMARY KEY,'
        'fullName TEXT,'
        'gender TEXT,'
        'phone TEXT,'
        'lastPaymentDate TEXT,'
        'lastPaymentType TEXT,'
        'registryDate TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.staff}('
        'rfid INTEGER PRIMARY KEY,'
        'fullName TEXT,'
        'role TEXT,'
        'isActive INTEGER,'
        'shiftType TEXT,'
        'startedWorkingFrom TEXT,'
        'phone TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.membersAttendance}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT,'
        'ownerId INTEGER,'
        'type TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.staffAttendance}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT,'
        'ownerId INTEGER,'
        'type TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.payments}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'ownerId INTEGER,'
        'startingDate TEXT,'
        'endingDate TEXT'
        ')');
  }

  // staff

  Future<int> insertStaff(Staff staff) async {
    var db = await database;
    var result = await db!.insert(DatabaseConst.staff, staff.toMap());

    return result;
  }

  Future<List<Staff>> getStaffs() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.staff);
    print(result);
    List<Staff> staffs = [];
    for (var staff in result) {
      staffs.add(Staff.fromMap(staff));
    }

    return staffs;
  }

  Future<List<Staff>> getStaffByRfid(String rfid) async {
    Database? db = await database;

    var result = await db!
        .query(DatabaseConst.staff, where: 'rfid = ?', whereArgs: [rfid]);
    List<Staff> staffs = [];
    for (var staff in result) {
      staffs.add(Staff.fromMap(staff));
    }

    return staffs;
  }

  Future<int> updateStaff(Staff staff) async {
    final db = await database;
    var result = await db!.update(DatabaseConst.staff, staff.toMap());

    return result;
  }

  Future<int> deleteStaff(int id) async {
    var db = await database;
    var result = await db!
        .rawDelete('DELETE FROM ${DatabaseConst.staff} WHERE id = $id');

    return result;
  }

  // members

  Future<int> insertMember(Member member) async {
    var db = await database;
    var result = await db!.insert(DatabaseConst.member, member.toMap());

    return result;
  }

  Future<List<Member>> getMembers() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.member);
    List<Member> members = [];
    for (var member in result) {
      members.add(Member.fromMap(member));
    }

    return members;
  }

  Future<int> updateMember(Member member) async {
    final db = await database;
    var result = await db!.update(DatabaseConst.member, member.toMap());

    return result;
  }

  Future<int> deleteMember(int id) async {
    var db = await database;
    var result = await db!
        .rawDelete('DELETE FROM ${DatabaseConst.member} WHERE id = $id');

    return result;
  }

  // memberAttendance

  Future<int> insertMemberAttendance(Attendance attendance) async {
    var db = await database;
    var result =
        await db!.insert(DatabaseConst.membersAttendance, attendance.toMap());

    return result;
  }

  Future<List<Attendance>> getMembersAttendance() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.membersAttendance);
    List<Attendance> attendances = [];
    for (var attendance in result) {
      attendances.add(Attendance.fromMap(attendance));
    }

    return attendances;
  }

  Future<int> updateMemberAttendance(Attendance attendance) async {
    final db = await database;
    var result =
        await db!.update(DatabaseConst.membersAttendance, attendance.toMap());

    return result;
  }

  // staffAttendance

  Future<int> insertStaffAttendance(Attendance attendance) async {
    var db = await database;
    var result =
        await db!.insert(DatabaseConst.staffAttendance, attendance.toMap());

    return result;
  }

  Future<List<Attendance>> getStaffAttendance() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.staffAttendance);
    List<Attendance> attendances = [];
    for (var attendance in result) {
      attendances.add(Attendance.fromMap(attendance));
    }

    return attendances;
  }

  Future<List<Attendance>> getStaffAttendanceOfMonth(
      int month, int year) async {
    Database? db = await database;

    String mon = month < 10 ? "0$month" : "$month";

    var result = await db!.query(
      DatabaseConst.staffAttendance,
      where: 'date LIKE ?',
      whereArgs: ['%$year-$mon%'],
    );

    List<Attendance> attendances = [];
    for (var attendance in result) {
      attendances.add(Attendance.fromMap(attendance));
    }

    return attendances;
  }

  Future<int> updateStaffAttendance(Attendance attendance) async {
    final db = await database;
    var result = await db!.update(
        DatabaseConst.staffAttendance, attendance.toMap(),
        where: 'id = ?', whereArgs: [attendance.id]);

    return result;
  }

  // payment

  Future<int> insertPayment(Payment payment) async {
    var db = await database;
    var result = await db!.insert(DatabaseConst.payments, payment.toMap());

    return result;
  }

  Future<List<Payment>> getPayments() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.payments);
    List<Payment> payments = [];
    for (var payment in result) {
      payments.add(Payment.fromMap(payment));
    }

    return payments;
  }

  Future<int> updatePayment(Payment payment) async {
    final db = await database;
    var result = await db!.update(DatabaseConst.payments, payment.toMap());

    return result;
  }

  Future<int> deletePayment(int id) async {
    var db = await database;
    var result = await db!
        .rawDelete('DELETE FROM ${DatabaseConst.payments} WHERE id = $id');

    return result;
  }
}



  // 'pdfPage DOUBLE,'
  // 'pdfNum DOUBLE,'
  // 'totalDuration INTEGER,'
  // 'audioSizes TEXT,'
  // 'isCompleted INTEGER'
  //check
  // Future<int?> isCourseAvailable(String courseId) async {
  //   Database? db = await database;
  //   try {
  //     var result = await db!.query(DatabaseConst.savedCourses,
  //         where: 'courseId = ?', whereArgs: [courseId]);
  //     return result.isNotEmpty ? int.parse(result[0]['id'].toString()) : null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<int?> isFAQAvailable(String question) async {
  //   Database? db = await database;
  //   try {
  //     var result = await db!.query(DatabaseConst.faq,
  //         where: 'question = ?', whereArgs: [question]);
  //     return result.isNotEmpty ? int.parse(result[0]['id'].toString()) : null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<int> countColumnsInTable(String table) async {
  //   final db = await database;

  //   final List<Map<String, dynamic>> tableInfo = await db!.rawQuery(
  //     'PRAGMA table_info($table)',
  //   );

  //   final columnCount = tableInfo.length;

  //   return columnCount;
  // }

  // Future<List<CourseModel>> searchCourses(String val) async {
  //   final db = await database;
  //   final searchQuery = '%$val%';

  //   const String query = '''
  //     SELECT * FROM courses
  //     WHERE title LIKE ?
  //     ORDER BY title
  //   ''';

  //   final List<Map<String, dynamic>> result =
  //       await db!.rawQuery(query, [searchQuery]);

  //   List<CourseModel> courses = [];
  //   for (var d in result) {
  //     courses.add(CourseModel.fromMap(d, d["courseId"]));
  //   }

  //   return courses;
  // }

  // //geting data
  // Future<List<CourseModel>> getCourseHistories() async {
  //   Database? db = await database;

  //   var result = await db!.query(
  //     DatabaseConst.savedCourses,
  //     orderBy: 'lastViewed DESC',
  //     // limit: 10,
  //   );
  //   List<CourseModel> courses = [];
  //   for (var courseDb in result) {
  //     courses
  //         .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
  //   }
  //   return courses;
  // }

  // Future<List<CourseModel>> getSavedCourses() async {
  //   Database? db = await database;

  //   var result =
  //       await db!.query(DatabaseConst.savedCourses, orderBy: 'lastViewed DESC');
  //   List<CourseModel> courses = [];
  //   for (var courseDb in result) {
  //     courses
  //         .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
  //   }
  //   return courses;
  // }

  // Future<CourseModel?> getSingleCourse(String courseId) async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.savedCourses,
  //       where: 'courseId = ?', whereArgs: [courseId]);
  //   List<CourseModel> courses = [];
  //   for (var courseDb in result) {
  //     courses
  //         .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
  //   }
  //   return courses.isEmpty ? null : courses.first;
  // }

  // Future<List<Map<String, dynamic>>> getCouses(
  //     String? key, dynamic val, SortingMethod method, int offset) async {
  //   final orderByColumn =
  //       method == SortingMethod.dateDSC ? 'dateTime' : 'title';
  //   final orderByDescending = method == SortingMethod.dateDSC ? 1 : 0;

  //   final db = await database;

  //   String query = "";
  //   List<Map<String, dynamic>> result = [];

  //   if (key == null) {
  //     query = '''
  //     SELECT * FROM ${DatabaseConst.savedCourses}
  //     ORDER BY $orderByColumn ${orderByDescending == 1 ? 'DESC' : 'ASC'}
  //     LIMIT $numOfDoc OFFSET $offset
  //     ''';
  //     result = await db!.rawQuery(query);
  //   } else {
  //     query = '''
  //     SELECT * FROM ${DatabaseConst.savedCourses}
  //     WHERE $key = ?
  //     ORDER BY $orderByColumn ${orderByDescending == 1 ? 'DESC' : 'ASC'}
  //     LIMIT $numOfDoc OFFSET $offset
  //     ''';
  //     result = await db!.rawQuery(query, [val]);
  //   }

  //   return result;
  // }

  // Future<List<String>> getCategories() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.cateogry);
  //   List<String> categories = [];
  //   for (var cat in result) {
  //     categories.add(cat['name'].toString());
  //   }

  //   return categories;
  // }

  // Future<int> insertCategory(String category) async {
  //   Database? db = await database;
  //   var result = await db!.insert(DatabaseConst.cateogry, {'name': category});

  //   return result;
  // }

  // Future<int> insertContent(String content) async {
  //   Database? db = await database;
  //   var result = await db!.insert(DatabaseConst.content, {'name': content});

  //   return result;
  // }

  // Future<int> insertUstaz(String ustaz) async {
  //   Database? db = await database;
  //   var result = await db!.insert(DatabaseConst.ustaz, {'name': ustaz});

  //   return result;
  // }

  // Future<int> insertFaq(FAQModel faq) async {
  //   final db = await database;
  //   var result = await db!.insert(DatabaseConst.faq, faq.toMap());

  //   return result;
  // }

  // Future<int> updateFaq(FAQModel faq) async {
  //   final db = await database;
  //   var result = await db!.update(DatabaseConst.faq, faq.toMap());

  //   return result;
  // }

  // Future<List<String>> getUstazs() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.ustaz);
  //   List<String> categories = [];
  //   for (var cat in result) {
  //     categories.add(cat['name'].toString());
  //   }

  //   return categories;
  // }

  // Future<List<String>> getContent() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.content, orderBy: "name");
  //   List<String> contents = [];
  //   for (var cat in result) {
  //     contents.add(cat['name'].toString());
  //   }

  //   return contents;
  // }

  // Future<List<FAQModel>> getFaqs() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.faq);
  //   List<FAQModel> categories = [];
  //   for (var d in result) {
  //     categories.add(FAQModel.fromMap(d, ""));
  //   }

  //   return categories;
  // }

  // Future<List<CourseModel>> getStartedCourses() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.savedCourses,
  //       orderBy: 'lastViewed DESC', where: 'isStarted = ?', whereArgs: [1]);
  //   List<CourseModel> courses = [];
  //   for (var courseDb in result) {
  //     courses
  //         .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
  //   }
  //   courses.sort((a, b) => b.lastViewed.compareTo(a.lastViewed));
  //   return courses;
  // }

  // Future<List<CourseModel>> getFavCourses() async {
  //   Database? db = await database;

  //   var result = await db!.query(DatabaseConst.savedCourses,
  //       orderBy: 'lastViewed ASC', where: 'isFav = ?', whereArgs: [1]);

  //   List<CourseModel> tasks = [];
  //   for (var taskDb in result) {
  //     tasks.add(CourseModel.fromMap(taskDb, taskDb['courseId'] as String));
  //   }
  //   return tasks;
  // }

  // //inserting data
  // // Future<int> insertCourse(CourseModel courseModel) async {
  // //   Database? db = await database;
  // //   var result =
  // //       await db!.insert(DatabaseConst.savedCourses, courseModel.toMap());

  // //   return result;
  // // }

  // //update data
  // Future<int> updateCourse(CourseModel courseModel) async {
  //   var db = await database;
  //   var result = await db!.update(
  //       DatabaseConst.savedCourses, courseModel.toMap(),
  //       where: 'id = ?', whereArgs: [courseModel.id]);

  //   return result;
  // }

  // Future<int> updateCourseFromCloud(CourseModel courseModel) async {
  //   var db = await database;
  //   var result = await db!.update(
  //       DatabaseConst.savedCourses, courseModel.toOriginalMap(),
  //       where: 'courseId = ?', whereArgs: [courseModel.courseId]);

  //   return result;
  // }

  // Future<int> insertCourse(CourseModel courseModel) async {
  //   var db = await database;
  //   var result =
  //       await db!.insert(DatabaseConst.savedCourses, courseModel.toMap());

  //   return result;
  // }

  // //deleta data
  // Future<int> deleteCourse(int id) async {
  //   var db = await database;
  //   var result = await db!
  //       .rawDelete('DELETE FROM ${DatabaseConst.savedCourses} WHERE id = $id');

  //   return result;
  // }
// }
