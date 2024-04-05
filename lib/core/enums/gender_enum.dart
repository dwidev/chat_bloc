import 'package:flutter/material.dart';

enum Gender {
  male,
  female;

  String get code => this == male ? "M" : "F";
  String get title => this == male ? "Male" : "Female";
  IconData get icon => this == male ? Icons.male : Icons.female;

  static Gender? fromCode(String code) {
    switch (code) {
      case "M":
        return Gender.male;
      case "F":
        return Gender.female;
      default:
        return null;
    }
  }
}
