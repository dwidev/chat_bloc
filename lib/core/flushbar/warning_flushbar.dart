// ignore_for_file: must_be_immutable

import 'package:chat_bloc/core/flushbar/base_flushbar.dart';
import 'package:chat_bloc/core/theme/colors.dart';

class WarningFlushBar extends BaseFlushBar {
  WarningFlushBar({super.key, required super.title, required super.message})
      : super(
          titleColor: primaryColor,
          messageColor: primaryColor,
        );
}
