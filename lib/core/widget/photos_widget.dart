import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../homepage/pages/home_page.dart';
import '../theme/colors.dart';

class PhotosPickerWidget extends StatelessWidget {
  const PhotosPickerWidget({
    super.key,
    this.backgroundColor,
    this.dashColor,
  });

  final Color? backgroundColor;
  final Color? dashColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.all(30),
      itemCount: dummyUsers.length - 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        if (index < 5) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    // color: darkColor,
                    image: DecorationImage(
                      image: NetworkImage(dummyUsers[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(right: 3, top: 3),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return InkWell(
          onTap: () {},
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: const [6, 3, 6, 3],
            padding: const EdgeInsets.all(2),
            radius: const Radius.circular(10),
            color: dashColor ?? darkColor.withOpacity(0.3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor ?? darkColor.withOpacity(0.04),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.camera,
                      color: blackColor,
                      size: 20,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Pick Photo",
                      style: textTheme.bodySmall?.copyWith(
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
