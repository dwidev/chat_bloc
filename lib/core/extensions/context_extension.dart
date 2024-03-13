import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get padTop => MediaQuery.of(this).padding.top;
  double get height => MediaQuery.of(this).size.height;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
