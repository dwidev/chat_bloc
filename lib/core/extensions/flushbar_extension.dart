import 'package:matchloves/core/flushbar/warning_flushbar.dart';
import 'package:flutter/cupertino.dart';

import '../dialog/loading_dialog.dart';

extension ContextShowFlushBarExtension on BuildContext {
  void showWarningFlush({required String message}) =>
      WarningFlushBar(title: "Warning!", message: message).show(this);

  void loading() => showLoading(this);
}
