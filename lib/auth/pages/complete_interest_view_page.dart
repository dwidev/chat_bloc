import 'package:chat_bloc/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
          width: size.width / 1.2,
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
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: interests
                .asMap()
                .map((key, e) => MapEntry(
                    key,
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (selected(e['name'])) {
                            selecteInterest.removeWhere(
                              (element) => element == e['name'],
                            );
                          } else {
                            selecteInterest.add(e['name']);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color:
                              selected(e['name']) ? primaryColor : whiteColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              e['icon'],
                              color: selected(e['name'])
                                  ? whiteColor
                                  : primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              e['name'],
                              style: textTheme.bodyMedium?.copyWith(
                                  color: selected(e['name'])
                                      ? whiteColor
                                      : darkColor),
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
                    )))
                .values
                .toList(),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
