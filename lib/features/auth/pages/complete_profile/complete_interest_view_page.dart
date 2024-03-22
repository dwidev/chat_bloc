import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/features/auth/bloc/complete_profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteInterstViewPage extends StatefulWidget {
  const CompleteInterstViewPage({
    super.key,
  });

  @override
  State<CompleteInterstViewPage> createState() =>
      _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteInterstViewPage> {
  List<Map<String, dynamic>> interests = [
    {"name": "Traveling", "icon": CupertinoIcons.airplane, "code": "TRAVELING"},
    {"name": "Foodie", "icon": Icons.local_dining, "code": "FOODIE"},
    {
      "name": "Outdoor Adventures",
      "icon": CupertinoIcons.tree,
      "code": "OUTDOOR_ADVENTURES"
    },
    {"name": "Fitness", "icon": CupertinoIcons.bolt, "code": "FITNESS"},
    {"name": "Movies", "icon": CupertinoIcons.film, "code": "MOVIES"},
    {
      "name": "Music/Spotify",
      "icon": CupertinoIcons.music_note,
      "code": "MUSIC_SPOTIFY"
    },
    {"name": "Art", "icon": CupertinoIcons.paintbrush, "code": "ART"},
    {"name": "Reading", "icon": CupertinoIcons.book, "code": "READING"},
    {
      "name": "Gaming",
      "icon": CupertinoIcons.game_controller,
      "code": "GAMING"
    },
    {
      "name": "Technology",
      "icon": CupertinoIcons.device_laptop,
      "code": "TECHNOLOGY"
    },
    {"name": "Fashion", "icon": CupertinoIcons.star, "code": "FASHION"},
    {"name": "Cooking", "icon": Icons.restaurant_rounded, "code": "COOKING"},
    {"name": "Sports", "icon": CupertinoIcons.sportscourt, "code": "SPORTS"}
  ];

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "I'm Interest for...",
          style: textTheme.bodyLarge?.copyWith(
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
            "Provide us with further insights into your interesting",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (context, state) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: interests
                    .asMap()
                    .map((key, e) {
                      final code = e["code"];
                      final name = e["name"];
                      final icon = e["icon"];
                      final isSelect = state.interests.selected(code);
                      return MapEntry(
                        key,
                        InkWell(
                          onTap: () {
                            completeBloc.add(
                              CompleteProfileSetInterestEvent(code: code),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isSelect ? primaryColor : whiteColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelect ? whiteColor : primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  name,
                                  style: textTheme.bodyMedium?.copyWith(
                                      color: isSelect ? whiteColor : darkColor),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fade(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(seconds: 1),
                              )
                              .slide(
                                begin: Offset(0, key + 2),
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn,
                              ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
