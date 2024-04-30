// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


enum AttendanceType{
  absent,
  present,
  late,
  permission,
  holyday,
  weekend,
}

class Attendance {
  final int? id;
  final String date;
  final int ownerId;
  final AttendanceType type;
  Attendance({
    required this.id,
    required this.date,
    required this.ownerId,
    required this.type,
  });

  Attendance copyWith({
    int? id,
    String? date,
    int? ownerId,
    AttendanceType? type, 
  }) {
    return Attendance(
      id: id ?? this.id,
      date: date ?? this.date,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'ownerId': ownerId,
      'type': type.toString(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] as int,
      date: map['date'] as String,
      ownerId: map['ownerId'] as int,
      type: AttendanceType.values.singleWhere((e) => e.toString() == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Attendance.fromJson(String source) => Attendance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Attendance(id: $id, date: $date, ownerId: $ownerId, type: $type)';
  }

  @override
  bool operator ==(covariant Attendance other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.ownerId == ownerId &&
      other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      ownerId.hashCode ^
      type.hashCode;
  }
}
