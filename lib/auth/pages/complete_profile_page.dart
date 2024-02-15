import 'dart:math';

import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/core/widget/gradient_button.dart';
import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'complete_gender_view_page.dart';
import 'complete_name_view_page.dart';
import 'login_page.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int pageIndex = 0;
  late double indicatorProgres;
  late Color linearColor;
  late PageController pageController;

  @override
  void initState() {
    indicatorProgres = 1 / 5;
    linearColor = secondaryColor;
    pageController = PageController();
    super.initState();
  }

  void onNext() {
    if (pageIndex == 4) {
      push(context: context, page: const HomePage());
      return;
    }
    setState(() {
      linearColor = linearColor.withBlue(Random().nextInt(255) + 50);
      indicatorProgres += 1 / 5;
      pageIndex = pageIndex + 1;
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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: indicatorProgres,
                      backgroundColor: secondaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CompleteNameViewPage(),
                  CompleteGenderViewPage(),
                  CompleteNameViewPage(),
                  CompleteGenderViewPage(),
                  CompleteNameViewPage(),
                ],
              ),
              Positioned(
                bottom: 20,
                child: GradientButton(
                  gradient: const LinearGradient(
                    colors: [Colors.black, primaryColor],
                  ),
                  onPressed: onNext,
                  child: Text(
                    "Next",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
