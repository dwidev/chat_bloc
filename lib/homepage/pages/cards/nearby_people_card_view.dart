// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class NearbyPeopleCardViewOptions {
  final double? imageWidth;
  final double? imageHeight;
  final bool isDetail;

  NearbyPeopleCardViewOptions({
    this.imageWidth,
    this.imageHeight,
    this.isDetail = false,
  });
}

class NearbyPeopleCardView extends StatelessWidget {
  const NearbyPeopleCardView({
    Key? key,
    required this.imageUrl,
    this.options,
  }) : super(key: key);

  final String imageUrl;

  final NearbyPeopleCardViewOptions? options;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: options?.isDetail ?? false ? BoxFit.cover : BoxFit.cover,
            ),
          ),
          width: options?.imageWidth ?? size.width / 1.2,
          height: options?.imageHeight ?? size.height / 1.5,
        ),
        Positioned(
          bottom: 15,
          right: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Michelle Ziudith, 23",
                          style: textTheme.bodyLarge?.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.location_solid,
                              size: 10,
                              color: whiteColor,
                            ),
                            Text(
                              "2km - Jakarta, DKI Jakarta",
                              style: textTheme.bodySmall?.copyWith(
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                children: [
                  [CupertinoIcons.person, '173cm'],
                  [CupertinoIcons.hare, 'Pisces'],
                  [CupertinoIcons.bag, 'Artis'],
                  [CupertinoIcons.clock, 'Online']
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(right: 5, top: 7),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5,
                                sigmaY: 5,
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      (e as List)[0],
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      (e as List)[1],
                                      style: textTheme.bodySmall?.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
