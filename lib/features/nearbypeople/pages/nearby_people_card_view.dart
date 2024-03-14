import 'dart:ui';

import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class NearbyPeopleCardViewOptions {
  final double? imageWidth;
  final double? imageHeight;
  final bool isDetail;
  final double radiusSize;

  NearbyPeopleCardViewOptions({
    this.imageWidth,
    this.imageHeight,
    this.isDetail = false,
    this.radiusSize = 25,
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
    final top = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(options?.radiusSize ?? 25),
              topRight: Radius.circular(options?.radiusSize ?? 25),
              bottomRight: Radius.circular(options?.radiusSize ?? 25),
              bottomLeft: Radius.circular(options?.radiusSize ?? 25),
            ),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: options?.isDetail ?? false ? BoxFit.cover : BoxFit.cover,
            ),
          ),
          width: options?.imageWidth ?? size.width / 1.045,
          height: options?.imageHeight ?? size.height / 1.5,
          // child: PageView(
          //   children: dummyUsers
          //       .map(
          //         (e) => Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(options?.radiusSize ?? 25),
          //               topRight: Radius.circular(options?.radiusSize ?? 25),
          //               bottomRight: Radius.circular(options?.radiusSize ?? 25),
          //               bottomLeft: Radius.circular(options?.radiusSize ?? 25),
          //             ),
          //             image: DecorationImage(
          //               image: NetworkImage(e),
          //               fit: options?.isDetail ?? false
          //                   ? BoxFit.cover
          //                   : BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //       )
          //       .toList(),
          // ),
        ),
        // Positioned(
        //   top: options?.isDetail ?? false ? top : 10,
        //   right: 10,
        //   child: Row(
        //     children: dummyUsers
        //         .asMap()
        //         .map((key, value) => MapEntry(
        //             key,
        //             Container(
        //               margin: const EdgeInsets.only(right: 10),
        //               decoration: BoxDecoration(
        //                 color: whiteColor,
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               width: key == 0 ? 100 : 10,
        //               height: 2,
        //             )))
        //         .values
        //         .toList(),
        //   ),
        // ),
        const CardPersonalInfoWidget(),
      ],
    );
  }
}

class CardPersonalInfoWidget extends StatelessWidget {
  const CardPersonalInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                    Row(
                      children: [
                        Text(
                          "Michelle Ziudith, 23",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: blueLightColor,
                        )
                      ],
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
                          style: context.textTheme.bodySmall?.copyWith(
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  style: context.textTheme.bodySmall?.copyWith(
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
    );
  }
}
