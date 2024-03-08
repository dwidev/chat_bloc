import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showImageDialog({
  required BuildContext context,
  required ImageProvider<Object> image,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              width: context.width / 2,
              height: context.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.clear,
                  color: whiteColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
