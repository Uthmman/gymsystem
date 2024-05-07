// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gymsystem/constants.dart';

class PaymentType {
  static String monthly = "Monthly";
  static String a3Months = "3 Months";
  static String a6Months = "6 Months";
  static String annual = 'Annual';

  DateTime getEndDate(String type, [DateTime? startFrom]) {
    startFrom = startFrom ?? DateTime.now();
    return DateTime.now();
    // if (type == monthly) {
    //   late DateTime endDate;
    //   if (startFrom.day < 12) {
    //   } else {}
    //   startDays = getDaysInMonth(startFrom.year, startFrom.month);
    //   endDays = getDaysInMonth(startFrom.year, startFrom.month);
    //   return DateTime(
    //     startFrom.year,
    //     startFrom.month + 1,
    //   );
    // } else if (type == a3Months) {
    //   return 90;
    // } else if (type == a6Months) {
    //   return 180;
    // } else {
    //   return 364;
    // }
  }
}

class Member {
  final String fullName;
  final String gender;
  final String phone;
  final String rfid;
  final String lastPaymentDate;
  final String lastPaymentType;
  final String registryDate;
  final String lastAttendance;
  Member({
    required this.fullName,
    required this.gender,
    required this.phone,
    required this.rfid,
    required this.lastPaymentDate,
    required this.lastPaymentType,
    required this.registryDate,
    required this.lastAttendance,
  });

  Member copyWith({
    String? fullName,
    String? gender,
    String? phone,
    String? rfid,
    String? lastPaymentDate,
    String? lastPaymentType,
    String? registryDate,
    String? lastAttendance,
  }) {
    return Member(
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      rfid: rfid ?? this.rfid,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      lastPaymentType: lastPaymentType ?? this.lastPaymentType,
      registryDate: registryDate ?? this.registryDate,
      lastAttendance: lastAttendance ?? this.lastAttendance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'gender': gender,
      'phone': phone,
      'rfid': rfid,
      'lastPaymentDate': lastPaymentDate,
      'lastPaymentType': lastPaymentType,
      'registryDate': registryDate,
      'lastAttendance': lastAttendance,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      fullName: map['fullName'] as String,
      gender: map['gender'] as String,
      phone: map['phone'] as String,
      rfid: map['rfid'] as String,
      lastPaymentDate: map['lastPaymentDate'] as String,
      lastPaymentType: map['lastPaymentType'] as String,
      registryDate: map['registryDate'] as String,
      lastAttendance: map['lastAttendance'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Member(fullName: $fullName, gender: $gender, phone: $phone, rfid: $rfid, lastPaymentDate: $lastPaymentDate, lastPaymentType: $lastPaymentType, registryDate: $registryDate, lastAttendance: $lastAttendance)';
  }

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.fullName == fullName &&
        other.gender == gender &&
        other.phone == phone &&
        other.rfid == rfid &&
        other.lastPaymentDate == lastPaymentDate &&
        other.lastPaymentType == lastPaymentType &&
        other.registryDate == registryDate &&
        other.lastAttendance == lastAttendance;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        rfid.hashCode ^
        lastPaymentDate.hashCode ^
        lastPaymentType.hashCode ^
        registryDate.hashCode ^
        lastAttendance.hashCode;
  }
}
