import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/core/widget/photos_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompleteUploadPhotoViewPage extends StatefulWidget {
  const CompleteUploadPhotoViewPage({
    super.key,
  });

  @override
  State<CompleteUploadPhotoViewPage> createState() =>
      _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteUploadPhotoViewPage> {
  List<Map<String, dynamic>> interests = [
    {"name": "Traveling", "icon": CupertinoIcons.airplane},
    {"name": "Foodie", "icon": Icons.local_dining},
    {"name": "Outdoor Adventures", "icon": CupertinoIcons.tree},
    {"name": "Fitness", "icon": CupertinoIcons.bolt},
    {"name": "Movies", "icon": CupertinoIcons.film},
    {"name": "Music/Spotify", "icon": CupertinoIcons.music_note},
    {"name": "Art", "icon": CupertinoIcons.paintbrush},
    {"name": "Reading", "icon": CupertinoIcons.book},
    {"name": "Gaming", "icon": CupertinoIcons.game_controller},
    {"name": "Technology", "icon": CupertinoIcons.device_laptop},
    {"name": "Fashion", "icon": CupertinoIcons.star},
    {"name": "Cooking", "icon": Icons.restaurant_rounded},
    {"name": "Sports", "icon": CupertinoIcons.sportscourt},
  ];
  List<String> selecteInterest = [];

  bool selected(String value) {
    return selecteInterest.where((e) => e == value).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "Upload Your Photos",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        SizedBox(
          width: size.width / 1.2,
          child: Text(
            "We'd love to see you. Upload a photo for your dating journey.",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        const SizedBox(height: 25),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const PhotosPickerWidget(
                backgroundColor: secondaryColor,
                dashColor: primaryColor,
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
