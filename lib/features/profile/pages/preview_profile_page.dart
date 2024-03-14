import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../homepage/pages/home_page.dart';
import '../../nearbypeople/pages/nearby_people_card_detail_page.dart';
import '../../nearbypeople/pages/nearby_people_card_view.dart';

class PreviewProfilePage extends StatefulWidget {
  const PreviewProfilePage({super.key});

  @override
  State<PreviewProfilePage> createState() => _PreviewProfilePageState();
}

class _PreviewProfilePageState extends State<PreviewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview", style: context.textTheme.bodyMedium),
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
                    Hero(
                      transitionOnUserGestures: true,
                      tag: dummyUsers[4],
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            push(
                              context: context,
                              page: NearbyPeopleCardDetailPage(
                                imageUrl: dummyUsers[4],
                              ),
                            );
                          },
                          child: NearbyPeopleCardView(
                            imageUrl: dummyUsers[4],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                bottom: 100,
                child: CardActionsWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
