import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../enums/photo_view_enum.dart';
import '../extensions/extensions.dart';
import '../widget/circle_icon_button.dart';

Future<void> showImageDialog({
  required BuildContext context,
  required ImageProvider<Object> image,
}) async {
  await showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        child: _PhotoViewWidget(image: image),
      );
    },
  );
}

class _PhotoViewWidget extends StatefulWidget {
  const _PhotoViewWidget({
    required this.image,
  });

  final ImageProvider<Object> image;

  @override
  State<_PhotoViewWidget> createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<_PhotoViewWidget> {
  PhotoViewEnum photoView = PhotoViewEnum.normal;

  void changePhotoView() {
    setState(() {
      if (photoView.isNormal) {
        photoView = PhotoViewEnum.fullScreen;
      } else {
        photoView = PhotoViewEnum.normal;
      }
    });
  }

  Duration get durationAnimate => 350.ms;
  Curve get curveAnimate => Curves.fastLinearToSlowEaseIn;

  @override
  Widget build(BuildContext context) {
    final width = switch (photoView) {
      PhotoViewEnum.fullScreen => context.width,
      _ => context.width / 2,
    };
    final height = switch (photoView) {
      PhotoViewEnum.fullScreen => context.height,
      _ => context.height / 2,
    };
    final top = switch (photoView) {
      PhotoViewEnum.fullScreen => context.padTop,
      _ => 10.0,
    };
    final actionSize = switch (photoView) {
      PhotoViewEnum.fullScreen => 50.0,
      _ => 40.0,
    };

    return GestureDetector(
      onDoubleTap: () {
        changePhotoView();
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          AnimatedContainer(
            duration: durationAnimate,
            curve: curveAnimate,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              image: DecorationImage(
                image: widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: durationAnimate,
            curve: curveAnimate,
            top: top,
            right: 10,
            child: Row(
              children: [
                CircleIconButton(
                  onPressed: () {
                    changePhotoView();
                  },
                  size: actionSize,
                  icon: photoView.icon,
                ),
                const SizedBox(width: 10),
                CircleIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  size: actionSize,
                  icon: CupertinoIcons.clear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
