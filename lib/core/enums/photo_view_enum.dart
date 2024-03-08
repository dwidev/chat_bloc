import 'package:flutter/cupertino.dart';

enum PhotoViewEnum {
  normal,
  fullScreen;

  bool get isFullScreen => this == fullScreen;
  bool get isNormal => this == normal;

  IconData get icon => switch (this) {
        fullScreen => CupertinoIcons.fullscreen_exit,
        _ => CupertinoIcons.fullscreen,
      };
}
