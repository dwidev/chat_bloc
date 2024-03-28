// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:matchloves/core/extensions/extensions.dart';
import 'package:matchloves/core/widget/gradient_button.dart';
import 'package:matchloves/features/main/pages/main_page.dart';
import 'package:matchloves/features/nearbypeople/pages/nearby_people_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/colors.dart';
import '../cubit/details_card_cubit.dart';

class NearbyPeopleCardDetailPage extends StatefulWidget {
  final String imageUrl;

  const NearbyPeopleCardDetailPage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<NearbyPeopleCardDetailPage> createState() =>
      _NearbyPeopleCardDetailPageState();

  static const path = 'detail-card';
}

class _NearbyPeopleCardDetailPageState
    extends State<NearbyPeopleCardDetailPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final isDetail = context.select<DetailsCardCubit, bool>(
    //   (p) => p.state.isDetail,
    // );
    // final detailsCardCubit = context.read<DetailsCardCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: size.width,
        height: size.height,
        child: ListView(
          padding: EdgeInsets.zero,
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.imageUrl,
              transitionOnUserGestures: true,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  SizedBox(
                    width: size.width / 1.045,
                    height: size.height / 2,
                    child: PageView(
                      children: dummyUsers
                          .map(
                            (e) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(e),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const CardPersonalInfoWidget(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.person_crop_circle_badge_checkmark,
                        color: softblueColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'About me',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc porta venenatis est non semper. Ut pellentesque eros ac quam semper pharetra. ",
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Education",
                            style: textTheme.bodySmall,
                          ),
                          const Text("Advance School"),
                          const SizedBox(height: 10),
                          Text(
                            "Workout",
                            style: textTheme.bodySmall,
                          ),
                          const Text("Sometimes"),
                          const SizedBox(height: 30),
                          Text(
                            "How do you drinking?",
                            style: textTheme.bodySmall,
                          ),
                          const Text("No"),
                          const SizedBox(height: 10),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Love langguage",
                            style: textTheme.bodySmall,
                          ),
                          const Text("Act of service"),
                          const SizedBox(height: 10),
                          Text(
                            "Communication style",
                            style: textTheme.bodySmall,
                          ),
                          const Text("Slowly responses"),
                          const SizedBox(height: 30),
                          Text(
                            "How often do you smoke?",
                            style: textTheme.bodySmall,
                          ),
                          const Text("Non-Smoker"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // const Divider(thickness: 0.5),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.sparkles,
                        color: Colors.yellow,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Interests',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: InterstingWidget(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GradientButton(
                    onPressed: () {},
                    width: size.width,
                    child: Text(
                      "Share Fahmi Dwi",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    onPressed: () {},
                    width: size.width,
                    child: Text(
                      "Report Fahmi Dwi",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    onPressed: () {},
                    width: size.width,
                    gradient: LinearGradient(colors: [darkColor, Colors.black]),
                    child: Text(
                      "Block Fahmi Dwi",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class InterstingWidget extends StatelessWidget {
  const InterstingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      children: ["Spotify", "Make-up", "Art", "Entertaint", "Ahtlete"]
          .map(
            (e) => Container(
              margin: const EdgeInsets.only(right: 10, top: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: e == "Spotify"
                        ? [
                            primaryColor.withOpacity(0.7),
                            secondaryColor,
                          ]
                        : [
                            Colors.grey.shade700,
                            Colors.grey.shade400,
                          ],
                    tileMode: TileMode.mirror,
                  )),
              child: Text(
                e,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
