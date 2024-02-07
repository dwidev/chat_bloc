import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:chat_bloc/nearbypeople/cubit/control_card_enum.dart';
import 'package:flutter/material.dart';

import '../../nearbypeople/pages/nearby_people_card_view.dart';
import '../../nearbypeople/pages/nearby_people_card_view_animation.dart';

class PreviewProfilePage extends StatefulWidget {
  const PreviewProfilePage({super.key});

  @override
  State<PreviewProfilePage> createState() => _PreviewProfilePageState();
}

class _PreviewProfilePageState extends State<PreviewProfilePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Preview", style: textTheme.bodyMedium),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // appBar,
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 30,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    NearbyPeopleCardView(imageUrl: dummyUsers[4]),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                child: const CardActionsWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
