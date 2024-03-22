import 'package:flutter/material.dart';

enum Gender {
  male,
  female;

  String get title => this == male ? "Male" : "Female";
  IconData get icon => this == male ? Icons.male : Icons.female;
}
