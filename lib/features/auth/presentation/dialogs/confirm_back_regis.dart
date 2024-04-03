import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';
import '../pages/login/login_page.dart';

Future<void> confirmBackCompleteProfileDialog(BuildContext context) async {
  await showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'Exit',
    context: context,
    pageBuilder: (context, a, s) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: context.width / 1.5,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure you want to back?",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "The data you've entered will be lost if you back",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 25),
                GradientButton(
                  width: context.width / 2,
                  noShadow: true,
                  onPressed: () {
                    context.replace(LoginPage.path);
                  },
                  child: Text(
                    "Leave",
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Text(
                    "Stay",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: darkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
