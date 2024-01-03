import 'dart:ui';

import '../../../core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/details_card_cubit.dart';

class NearbyPeopleCardDetailView extends StatelessWidget {
  const NearbyPeopleCardDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDetail = context.select<DetailsCardCubit, bool>(
      (p) => p.state.isDetail,
    );
    final detailsCardCubit = context.read<DetailsCardCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: isDetail ? size.width : 0,
      height: isDetail ? size.height : 0,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: detailsCardCubit.widthCardAnimation.value,
            height: detailsCardCubit.heightCardAnimation.value,
          ),
          const SizedBox(height: 10),
          // Row(
          //   children: dummyUsers
          //       .map(
          //         (e) => Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           width: 70,
          //           height: 70,
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //                 image: NetworkImage(e), fit: BoxFit.cover),
          //           ),
          //         ),
          //       )
          //       .toList(),
          // ),
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
          Wrap(
            children: ["Spotify", "Make-up", "Art", "Entertaint", "Ahtlete"]
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
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
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Share"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Report"),
          ),
          ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Block"),
          ),
          const SizedBox(height: 100),
          // Wrap(
          //   children: [
          //     Row(
          //       children: [
          //         const Icon(CupertinoIcons.archivebox),
          //         const SizedBox(width: 5),
          //         Text('Dringking', style: textTheme.bodySmall),
          //       ],
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
