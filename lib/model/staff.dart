// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Staff {
  final String fullName;
  final String role;
  final String startedWorkingFrom;
  final String phone;
  final int isActive;
  final String shiftType;
  final int rfId;
  Staff({
    required this.fullName,
    required this.role,
    required this.startedWorkingFrom,
    required this.phone,
    required this.isActive,
    required this.shiftType,
    required this.rfId,
  });
  

  Staff copyWith({
    String? fullName,
    String? role,
    String? startedWorkingFrom,
    String? phone,
    int? isActive,
    String? shiftType,
    int? rfId,
  }) {
    return Staff(
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      startedWorkingFrom: startedWorkingFrom ?? this.startedWorkingFrom,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      shiftType: shiftType ?? this.shiftType,
      rfId: rfId ?? this.rfId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'role': role,
      'startedWorkingFrom': startedWorkingFrom,
      'phone': phone,
      'isActive': isActive,
      'shiftType': shiftType,
      'rfId': rfId,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      fullName: map['fullName'] as String,
      role: map['role'] as String,
      startedWorkingFrom: map['startedWorkingFrom'] as String,
      phone: map['phone'] as String,
      isActive: map['isActive'] as int,
      shiftType: map['shiftType'] as String,
      rfId: map['rfid'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Staff(fullName: $fullName, role: $role, startedWorkingFrom: $startedWorkingFrom, phone: $phone, isActive: $isActive, shiftType: $shiftType, rfId: $rfId)';
  }

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;
  
    return 
      other.fullName == fullName &&
      other.role == role &&
      other.startedWorkingFrom == startedWorkingFrom &&
      other.phone == phone &&
      other.isActive == isActive &&
      other.shiftType == shiftType &&
      other.rfId == rfId;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
      role.hashCode ^
      startedWorkingFrom.hashCode ^
      phone.hashCode ^
      isActive.hashCode ^
      shiftType.hashCode ^
      rfId.hashCode;
  }
}
