import 'package:chat_bloc/core/flushbar/warning_flushbar.dart';
import 'package:flutter/cupertino.dart';

extension ContextShowFlushBarExtension on BuildContext {
  void showWarningFlush({required String message}) =>
      WarningFlushBar(title: "Warning!", message: message).show(this);
}
