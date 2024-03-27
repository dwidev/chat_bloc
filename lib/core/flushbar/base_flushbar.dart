// ignore_for_file: must_be_immutable

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/colors.dart';

abstract class BaseFlushBar extends Flushbar {
  BaseFlushBar({
    required String title,
    required String message,
    Color? titleColor,
    Color? messageColor,
    super.key,
  }) : super(
          title: title,
          message: message,
          titleColor: titleColor ?? darkColor,
          messageColor: messageColor ?? darkColor,
          flushbarPosition: FlushbarPosition.TOP,
          duration: 2.seconds,
          backgroundColor: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderRadius: BorderRadius.circular(10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          boxShadows: [
            BoxShadow(
              color: darkColor.withOpacity(0.1),
              offset: const Offset(0.2, 0.2),
              blurRadius: 20,
            )
          ],
        );
}
