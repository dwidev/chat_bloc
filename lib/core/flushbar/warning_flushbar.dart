// ignore_for_file: must_be_immutable

import 'package:matchloves/core/flushbar/base_flushbar.dart';
import 'package:matchloves/core/theme/colors.dart';

class WarningFlushBar extends BaseFlushBar {
  WarningFlushBar({super.key, required super.title, required super.message})
      : super(
          titleColor: primaryColor,
          messageColor: primaryColor,
        );
}
