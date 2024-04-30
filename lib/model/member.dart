// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Member {
  final String fullName;
  final String gender;
  final String phone;
  final int rfid;
  final String lastPaymentDate;
  final String lastPaymentType;
  final String registryDate;
  
  Member({
    required this.fullName,
    required this.gender,
    required this.phone,
    required this.rfid,
    required this.lastPaymentDate,
    required this.lastPaymentType,
    required this.registryDate,
  });

  Member copyWith({
    String? fullName,
    String? gender,
    String? phone,
    int? rfid,
    String? lastPaymentDate,
    String? lastPaymentType,
    String? registryDate,
  }) {
    return Member(
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      rfid: rfid ?? this.rfid,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      lastPaymentType: lastPaymentType ?? this.lastPaymentType,
      registryDate: registryDate ?? this.registryDate,
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
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      fullName: map['fullName'] as String,
      gender: map['gender'] as String,
      phone: map['phone'] as String,
      rfid: map['rfid'] as int,
      lastPaymentDate: map['lastPaymentDate'] as String,
      lastPaymentType: map['lastPaymentType'] as String,
      registryDate: map['registryDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Member(fullName: $fullName, gender: $gender, phone: $phone, rfid: $rfid, lastPaymentDate: $lastPaymentDate, lastPaymentType: $lastPaymentType, registryDate: $registryDate)';
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
        other.registryDate == registryDate;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        rfid.hashCode ^
        lastPaymentDate.hashCode ^
        lastPaymentType.hashCode ^
        registryDate.hashCode;
  }
}
