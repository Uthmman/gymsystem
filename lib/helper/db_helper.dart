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

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}$dbPath';

    var notesDatabase = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 10,
        onCreate: _createDb,
      ),
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
    print("table created");
    await db.execute('CREATE TABLE ${DatabaseConst.staff}('
        'rfId TEXT PRIMARY KEY,'
        'fullName TEXT,'
        'role TEXT,'
        'startedWorkingFrom TEXT,'
        'phone TEXT,'
        'entranceTime TEXT,'
        'exitTime TEXT,'
        'dateOfBirth TEXT,'
        'lastAttendance TEXT,'
        'gender TEXT,'
        'defaultAttendance TEXT,'
        'isActive INTEGER'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.member}('
        "rfid TEXT PRIMARY KEY,"
        'fullName TEXT,'
        "gender TEXT,"
        "phone TEXT,"
        "lastPaymentDate TEXT,"
        "lastPaymentType TEXT,"
        "registryDate TEXT,"
        "lastAttendance TEXT"
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.membersAttendance}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT,'
        'ownerId TEXT,'
        'type TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.staffAttendance}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT,'
        'ownerId TEXT,'
        'type TEXT'
        ')');
    await db.execute('CREATE TABLE ${DatabaseConst.payments}('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'ownerId TEXT,'
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

  Future<List<Staff>> searchStaffs(String query) async {
    Database? db = await database;

    var result = await db!.query(
      DatabaseConst.staff,
      where: 'fullName LIKE ?',
      whereArgs: ['%$query%'],
    );

    List<Staff> staffs = [];
    for (var staff in result) {
      staffs.add(Staff.fromMap(staff));
    }
    print('search staffs: $staffs');

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

  Future<int?> updateStaff(Staff staff, String? oldRfid) async {
    if (oldRfid != null && staff.rfId != oldRfid) {
      updateStaffWithRfId(staff, oldRfid);
      return null;
    } else {
      final db = await database;
      var result = await db!.update(
        DatabaseConst.staff,
        staff.toMap(),
        where: 'rfid = ?',
        whereArgs: [staff.rfId],
      );
      return result;
    }
  }

  Future<void> updateStaffWithRfId(Staff staff, String rfid) async {
    await insertStaff(staff);
    await updateStaffsThing(rfid, staff.rfId);
    await deleteStaff(rfid);
  }

  Future<int> deleteStaff(String id) async {
    var db = await database;

    var result = await db!.delete(
      DatabaseConst.staff,
      where: 'rfid = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseConst.staffAttendance,
      where: 'ownerId = ?',
      whereArgs: [id],
    );

    return result;
  }

  // members

  Future<int> insertMember(Member member) async {
    var db = await database;
    var result = await db!.insert(DatabaseConst.member, member.toMap());

    return result;
  }

  Future<List<Member>> searchMembers(String query) async {
    Database? db = await database;

    var result = await db!.query(
      DatabaseConst.member,
      where: 'fullName LIKE ?',
      whereArgs: ['%$query%'],
    );

    List<Member> members = [];
    for (var member in result) {
      members.add(Member.fromMap(member));
    }
    print('search members: $members');

    return members;
  }

  Future<List<Member>> getMemberByRfid(String rfid) async {
    Database? db = await database;

    var result = await db!
        .query(DatabaseConst.member, where: 'rfid = ?', whereArgs: [rfid]);
    List<Member> members = [];
    for (var member in result) {
      members.add(Member.fromMap(member));
    }

    return members;
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

  Future<int?> updateMember(Member member, String? oldRfid) async {
    if (oldRfid != null && member.rfid != oldRfid) {
      updateMemberWithRfId(member, oldRfid);
      return null;
    } else {
      final db = await database;
      var result = await db!.update(
        DatabaseConst.member,
        member.toMap(),
        where: 'rfid = ?',
        whereArgs: [member.rfid],
      );
      return result;
    }
  }

  Future<void> updateMemberWithRfId(Member member, String rfid) async {
    await insertMember(member);
    await updateMembersThing(rfid, member.rfid);
    await deleteMember(rfid);
  }

  Future<int> deleteMember(String id) async {
    var db = await database;
    var result = await db!.delete(
      DatabaseConst.member,
      where: 'rfid = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseConst.payments,
      where: 'ownerId = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseConst.membersAttendance,
      where: 'ownerId = ?',
      whereArgs: [id],
    );
    // var result = await db!
    //     .rawDelete('DELETE FROM ${DatabaseConst.member} WHERE rfid = $id');
    // await db
    //     .rawDelete('DELETE FROM ${DatabaseConst.payments} WHERE ownerId = $id');
    // await db.rawDelete(
    //     'DELETE FROM ${DatabaseConst.membersAttendance} WHERE ownerId = $id');

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

  Future<List<Attendance>> getMembersAttendanceOfMonth(
      int month, int year) async {
    Database? db = await database;

    String mon = month < 10 ? "0$month" : "$month";

    print("%$year-$mon%");

    var result = await db!.query(
      DatabaseConst.membersAttendance,
      where: 'date LIKE ?',
      whereArgs: ['%$year-$mon%'],
    );

    List<Attendance> attendances = [];
    for (var attendance in result) {
      attendances.add(Attendance.fromMap(attendance));
    }
    print(attendances);

    return attendances;
  }

  Future<List<Attendance>> getMembersAttendanceOfDay(DateTime date) async {
    Database? db = await database;

    final day = date.toString().split(" ")[0];
    var result = await db!.query(
      DatabaseConst.membersAttendance,
      where: 'date LIKE ?',
      whereArgs: ['%$day%'],
    );

    List<Attendance> attendnces = [];
    for (var attendance in result) {
      attendnces.add(Attendance.fromMap(attendance));
    }

    return attendnces;
  }

  Future<void> updateMembersAttendancesOnADay(
      DateTime dateTime, AttendanceType type) async {
    final attendances = await getMembersAttendanceOfDay(dateTime);

    for (Attendance attendance in attendances) {
      await updateMemberAttendance(attendance.copyWith(type: type));
    }
  }

  Future<void> updateMembersThing(String oldRfid, String newRfid) async {
    Database? db = await database;
    await db!.update(
      DatabaseConst.membersAttendance,
      {'ownerId': newRfid},
      where: 'ownerId = ?',
      whereArgs: [oldRfid],
    );
    await db.update(
      DatabaseConst.payments,
      {'ownerId': newRfid},
      where: 'ownerId = ?',
      whereArgs: [oldRfid],
    );
  }

  Future<Member?> scanMembersAttendance(String rfId) async {
    final members = await getMemberByRfid(rfId);

    if (members.isEmpty) {
      return null;
    }

    final member = members[0];

    final attendances = await getMembersAttendanceOfDay(DateTime.now());

    for (Attendance attendance in attendances) {
      if (attendance.ownerId == rfId) {
        final res = await updateMemberAttendance(
          attendance.copyWith(
            type: AttendanceType.present,
            date: DateTime.now().toString(),
          ),
        );
        print("here");
        return member;
      }
    }
    return member;
  }

  Future<int> updateMemberAttendance(Attendance attendance) async {
    final db = await database;
    var result = await db!.update(
      DatabaseConst.membersAttendance,
      attendance.toMap(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );

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

    print("%$year-$mon%");

    var result = await db!.query(
      DatabaseConst.staffAttendance,
      where: 'date LIKE ?',
      whereArgs: ['%$year-$mon%'],
    );

    List<Attendance> attendances = [];
    for (var attendance in result) {
      attendances.add(Attendance.fromMap(attendance));
    }
    print(attendances);

    return attendances;
  }

  Future<List<Attendance>> getStaffAttendanceOfDay(DateTime date) async {
    Database? db = await database;

    final day = date.toString().split(" ")[0];
    var result = await db!.query(
      DatabaseConst.staffAttendance,
      where: 'date LIKE ?',
      whereArgs: ['%$day%'],
    );

    List<Attendance> attendnces = [];
    for (var attendance in result) {
      attendnces.add(Attendance.fromMap(attendance));
    }

    return attendnces;
  }

  Future<void> updateStaffsThing(String oldRfid, String newRfid) async {
    Database? db = await database;
    await db!.update(
      DatabaseConst.staffAttendance,
      {'ownerId': newRfid},
      where: 'ownerId = ?',
      whereArgs: [oldRfid],
    );
  }

  Future<void> updateStaffAttendancesOnADay(
      DateTime dateTime, AttendanceType type) async {
    final attendances = await getStaffAttendanceOfDay(dateTime);

    for (Attendance attendance in attendances) {
      await updateStaffAttendance(attendance.copyWith(type: type));
    }
  }

  Future<Staff?> scanStaffAttendance(String rfId) async {
    final staffs = await getStaffByRfid(rfId);

    if (staffs.isEmpty) {
      return null;
    }

    final staff = staffs[0];

    final entranceTime = parseTimeString(staff.entranceTime);
    print('entranceTime: $entranceTime');
    print("now: ${DateTime.now()}");

    final isLate = entranceTime.compareTo(DateTime.now()) < 0;

    final attendances = await getStaffAttendanceOfDay(DateTime.now());

    for (Attendance attendance in attendances) {
      if (attendance.ownerId == rfId) {
        final res = await updateStaffAttendance(
          attendance.copyWith(
            type: isLate ? AttendanceType.late : AttendanceType.present,
            date: DateTime.now().toString(),
          ),
        );
        return staff;
      }
    }
    return null;
  }

  // Future<int> scanStaffAttendance(Attendance attendance) async {
  //   Database? db = await database;

  //   String today = DateTime.now().toString().split(' ')[0];

  //   var result = await db!.query(
  //     DatabaseConst.staffAttendance,
  //     where: 'date LIKE ?',
  //     whereArgs: ['%$today%'],
  //   );

  //   List<Attendance> attendances = [];
  //   for (var attendance in result) {
  //     attendances.add(Attendance.fromMap(attendance));
  //   }
  //   print(attendances);

  // }

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

  Future<List<Payment>> getPaymentsOfaMember(String rfId) async {
    Database? db = await database;

    var result = await db!.query(
      DatabaseConst.payments,
      where: 'ownerId = ?',
      whereArgs: [rfId],
    );

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
