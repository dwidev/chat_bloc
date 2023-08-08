// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String name;
  final String status;
  final String statusDate;

  bool get online => status == "online";
  bool get offline => status == "offline";

  String get lastWatch {
    final dateNow = DateTime.now();
    final statusDate = DateTime.parse(this.statusDate).toLocal();
    if (dateNow.day != statusDate.day) {
      final lastWatch = DateFormat("dd/MM/yyyy HH:mm").format(statusDate);
      return lastWatch;
    }

    final lastWatch = DateFormat("HH:mm").format(statusDate);
    return lastWatch;
  }

  String get lastSeen {
    final dateNow = DateTime.now();
    final userDate = DateTime.tryParse(statusDate)?.toLocal();

    if (userDate == null) {
      return '';
    }

    final days = dateNow.difference(userDate).inDays;
    final hours = dateNow.difference(userDate).inHours;
    final minute = dateNow.difference(userDate).inMinutes;
    final second = dateNow.difference(userDate).inSeconds;

    if (days >= 1) {
      return "Terlihat $days hari yang lalu";
    } else if (hours >= 1) {
      return "Terlihat $hours jam yang lalu";
    } else if (minute >= 1) {
      return "Terlihat $minute menit yang lalu";
    } else if (second >= 0) {
      if (second <= 0) {
        return "Terlihat Baru saja";
      }

      return "Baru saja $second detik yang lalu";
    } else {
      return "Terlihat Baru saja";
    }
  }

  UserModel({
    required this.id,
    required this.name,
    required this.status,
    required this.statusDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'statusDate': statusDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      statusDate: map['statusDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, status: $status, statusDate: $statusDate)';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? status,
    String? statusDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      statusDate: statusDate ?? this.statusDate,
    );
  }
}
