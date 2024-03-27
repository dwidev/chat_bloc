import 'package:chat_bloc/features/auth/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/photos_picker/photos_picker.dart';
import '../../../../core/theme/colors.dart';

class CompleteUploadPhotoViewPage extends StatelessWidget {
  const CompleteUploadPhotoViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "Upload Your Photos",
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        SizedBox(
          width: context.width / 1.2,
          child: Text(
            "We'd love to see you. Upload a photo for your dating journey.",
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        const SizedBox(height: 30),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PhotosPickerWidget(
                backgroundColor: secondaryColor,
                dashColor: primaryColor,
                initialImages: completeBloc.state.photoProfiles,
                onSelectedImage: (images) {
                  completeBloc.add(
                    CompleteProfileSetPhotoEvent(imagesPicked: images),
                  );
                },
              ).animate().fade(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(seconds: 1),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
