// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Payment {
  final int? id;
  final String ownerId;
  final String startingDate;
  final String endingDate;
  final String type;
  Payment({
    required this.id,
    required this.ownerId,
    required this.startingDate,
    required this.endingDate,
    required this.type,
  });

  Payment copyWith({
    int? id,
    String? ownerId,
    String? startingDate,
    String? endingDate,
    String? type,
  }) {
    return Payment(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      startingDate: startingDate ?? this.startingDate,
      endingDate: endingDate ?? this.endingDate,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'type': type,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int,
      ownerId: map['ownerId'] as String,
      startingDate: map['startingDate'] as String,
      endingDate: map['endingDate'] as String,
      type: map['type'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Payment(id: $id, ownerId: $ownerId, startingDate: $startingDate, endingDate: $endingDate)';
  }

  @override
  bool operator ==(covariant Payment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.startingDate == startingDate &&
        other.endingDate == endingDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        startingDate.hashCode ^
        endingDate.hashCode;
  }
}
