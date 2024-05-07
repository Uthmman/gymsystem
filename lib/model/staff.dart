// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gymsystem/model/attendance.dart';

class Staff {
  final String fullName;
  final String role;
  final String startedWorkingFrom;
  final String phone;
  final String entranceTime;
  final String exitTime;
  final String dateOfBirth;
  final String lastAttendance;
  final String gender;
  final AttendanceType defaultAttendance;
  final int isActive;
  final String rfId;
  Staff(
      {required this.fullName,
      required this.role,
      required this.startedWorkingFrom,
      required this.phone,
      required this.entranceTime,
      required this.exitTime,
      required this.lastAttendance,
      required this.gender,
      required this.defaultAttendance,
      required this.isActive,
      required this.rfId,
      required this.dateOfBirth});

  Staff copyWith({
    String? fullName,
    String? role,
    String? startedWorkingFrom,
    String? phone,
    String? entranceTime,
    String? exitTime,
    String? dateOfBirth,
    String? lastAttendance,
    String? gender,
    AttendanceType? defaultAttendance,
    int? isActive,
    String? rfId,
  }) {
    return Staff(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      startedWorkingFrom: startedWorkingFrom ?? this.startedWorkingFrom,
      phone: phone ?? this.phone,
      entranceTime: entranceTime ?? this.entranceTime,
      exitTime: exitTime ?? this.exitTime,
      lastAttendance: lastAttendance ?? this.lastAttendance,
      gender: gender ?? this.gender,
      defaultAttendance: defaultAttendance ?? this.defaultAttendance,
      isActive: isActive ?? this.isActive,
      rfId: rfId ?? this.rfId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'role': role,
      'startedWorkingFrom': startedWorkingFrom,
      'phone': phone,
      'entranceTime': entranceTime,
      'exitTime': exitTime,
      'lastAttendance': lastAttendance,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'defaultAttendance': defaultAttendance.toString(),
      'isActive': isActive,
      'rfId': rfId,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      fullName: map['fullName'] as String,
      role: map['role'] as String,
      startedWorkingFrom: map['startedWorkingFrom'] as String,
      phone: map['phone'] as String,
      entranceTime: map['entranceTime'] as String,
      exitTime: map['exitTime'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      lastAttendance: map['lastAttendance'] as String,
      gender: map['gender'] as String,
      defaultAttendance: AttendanceType.values
          .singleWhere((e) => e.toString() == map['defaultAttendance']),
      isActive: map['isActive'] as int,
      rfId: map['rfId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) =>
      Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Staff(fullName: $fullName, role: $role, startedWorkingFrom: $startedWorkingFrom, phone: $phone, entranceTime: $entranceTime, exitTime: $exitTime, lastAttendance: $lastAttendance, gender: $gender, defaultAttendance: $defaultAttendance, isActive: $isActive, rfId: $rfId)';
  }

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;

    return other.fullName == fullName &&
        other.role == role &&
        other.startedWorkingFrom == startedWorkingFrom &&
        other.phone == phone &&
        other.entranceTime == entranceTime &&
        other.exitTime == exitTime &&
        other.lastAttendance == lastAttendance &&
        other.gender == gender &&
        other.defaultAttendance == defaultAttendance &&
        other.isActive == isActive &&
        other.rfId == rfId;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        role.hashCode ^
        startedWorkingFrom.hashCode ^
        phone.hashCode ^
        entranceTime.hashCode ^
        exitTime.hashCode ^
        lastAttendance.hashCode ^
        gender.hashCode ^
        defaultAttendance.hashCode ^
        isActive.hashCode ^
        rfId.hashCode;
  }
}
