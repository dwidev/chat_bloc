import 'package:flutter/material.dart';
import 'package:matchloves/core/flushbar/warning_flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:matchloves/features/auth/presentation/dialogs/confirm_back_regis.dart';

import '../dialog/loading_dialog.dart';

extension ContextShowFlushBarExtension on BuildContext {
  void showWarningFlush({required String message}) =>
      WarningFlushBar(title: "Warning!", message: message).show(this);

  void loading() => showLoading(this);

  Future<void> completeBackConfirm(
          {required Future<void> Function() onClose}) async =>
      await confirmBackCompleteProfileDialog(this, onClose: onClose);
}
