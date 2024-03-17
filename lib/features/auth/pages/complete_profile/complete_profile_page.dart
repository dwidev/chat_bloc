import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';
import '../allow_permission_location_page.dart';
import 'complete_age_view_page.dart';
import 'complete_distance_view_page.dart';
import 'complete_gender_view_page.dart';
import 'complete_interest_view_page.dart';
import 'complete_looking_for_view_page.dart';
import 'complete_name_view_page.dart';
import 'complete_upload_photo_view_page.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();

  static const path = 'complete-profile';
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int pageIndex = 0;
  late double indicatorProgres;
  late Color linearColor;
  late PageController pageController;

  static const pages = [
    CompleteNameViewPage(),
    CompleteGenderViewPage(),
    CompleteAgeViewPage(),
    CompleteDistanceViewPage(),
    CompleteLookingForViewPage(),
    CompleteInterstViewPage(),
    CompleteUploadPhotoViewPage(),
  ];

  int get pageLenth => pages.length;

  @override
  void initState() {
    indicatorProgres = 1 / pageLenth;
    linearColor = softPinkColor;
    pageController = PageController();
    super.initState();
  }

  void onNext() {
    if (pageIndex == pageLenth - 1) {
      context.go(AllowPermissionLocationPage.path);
      return;
    }

    setState(() {
      linearColor = primaryColor.withAlpha(Random().nextInt(255));
      indicatorProgres += 1 / pageLenth;
      pageIndex = pageIndex + 1;
    });
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  void onPrev() {
    if (pageIndex == 0) {
      return;
    }
    setState(() {
      linearColor = primaryColor.withAlpha(Random().nextInt(255) + 50);
      indicatorProgres -= 1 / pageLenth;
      pageIndex = pageIndex - 1;
    });
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              linearColor,
              whiteColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: padding.top / 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  height: 10,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: indicatorProgres),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: secondaryColor.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
              )
                  .animate()
                  .slide(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 200),
                  )
                  .fade(),
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
              Positioned(
                bottom: 20,
                left: 30,
                child: AnimatedOpacity(
                  opacity: pageIndex > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: InkWell(
                    onTap: onPrev,
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(CupertinoIcons.back, color: blackColor),
                    ),
                  )
                      .animate()
                      .boxShadow(borderRadius: BorderRadius.circular(15))
                      .fade(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(seconds: 1),
                      ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                right: pageIndex > 0 ? 30 : 50,
                bottom: 20,
                child: GradientButton(
                  width: pageIndex > 0 ? 100 : null,
                  gradient: LinearGradient(
                    colors: [primaryColor, darkColor],
                  ),
                  onPressed: onNext,
                  child: Text(
                    "Next",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .boxShadow(borderRadius: BorderRadius.circular(20))
                    .fade(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(seconds: 1),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
