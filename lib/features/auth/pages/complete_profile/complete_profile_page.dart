import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/dialog/loading_dialog.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/extensions/flushbar_extension.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';
import '../../../masterdata/cubit/master_data_cubit.dart';
import '../../bloc/complete_profile_bloc.dart';
import '../allow_permission_location_page.dart';
import 'complete_age_view_page.dart';
import 'complete_distance_view_page.dart';
import 'complete_gender_view_page.dart';
import 'complete_interest_view_page.dart';
import 'complete_looking_for_view_page.dart';
import 'complete_name_view_page.dart';
import 'complete_upload_photo_view_page.dart';

abstract class CompleteProfilePageDelegate {
  onNext();
  onPrev();
}

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();

  static const path = 'complete-profile';
}

class _CompleteProfilePageState extends State<CompleteProfilePage>
    with TickerProviderStateMixin
    implements CompleteProfilePageDelegate {
  int pageIndex = 0;
  late double indicatorProgres;
  late Color linearColor;
  late final PageController pageController;
  late final AnimationController genderController =
      AnimationController(vsync: this, duration: 500.ms);

  late final pages = [
    const CompleteNameViewPage(), // 0
    CompleteGenderViewPage(
      delegate: this,
      controller: genderController,
    ), // 1
    const CompleteAgeViewPage(), // 2
    const CompleteDistanceViewPage(), // 3
    const CompleteLookingForViewPage(), // 4
    const CompleteInterstViewPage(), // 5
    const CompleteUploadPhotoViewPage(), // 6
  ];

  int get pageLenth => pages.length;

  @override
  void initState() {
    indicatorProgres = 1 / pageLenth;
    linearColor = softPinkColor;
    pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataCubit>().getCompleteProfileMaster();
    });
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("DISPOSING CompleteProfilePage");
    super.dispose();
  }

  @override
  void onNext() {
    if (!validation) return;

    void goToPage() {
      setState(() {
        linearColor = softPinkColor.withAlpha(Random().nextInt(255));
        indicatorProgres += 1 / pageLenth;
        pageIndex = pageIndex + 1;
      });
      pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }

    if (pageIndex == pageLenth - 1) {
      context.go(AllowPermissionLocationPage.path);
      return;
    }

    if (pageIndex == 1) {
      genderController.reverse().whenComplete(() {
        goToPage();
      });
    } else {
      goToPage();
    }
  }

  @override
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

  bool get validation {
    if (pageIndex == 0 && !validateName) return false;
    if (pageIndex == 1 && !validateGender) return false;
    if (pageIndex == 4 && !validateLooking) return false;
    if (pageIndex == 5 && !validateInterest) return false;
    if (pageIndex == 6 && !validatePhotoProfile) return false;

    return true;
  }

  bool get validateName {
    final prov = context.read<CompleteProfileBloc>();
    if (prov.state.name.isEmpty) {
      context.showWarningFlush(message: "Please fill name");
      return false;
    }

    return true;
  }

  bool get validateGender {
    final prov = context.read<CompleteProfileBloc>();
    if (prov.state.gender == null) {
      context.showWarningFlush(message: "Please select your gender");
      return false;
    }

    return true;
  }

  bool get validateLooking {
    final prov = context.read<CompleteProfileBloc>();
    if (prov.state.lookingForCode.isEmpty) {
      context.showWarningFlush(message: "Please select your looking for");
      return false;
    }

    return true;
  }

  bool get validateInterest {
    final prov = context.read<CompleteProfileBloc>();
    if (prov.state.interests.codes.isEmpty) {
      context.showWarningFlush(message: "Select min 1 for your interest");
      return false;
    }

    return true;
  }

  bool get validatePhotoProfile {
    final prov = context.read<CompleteProfileBloc>();
    if (prov.state.photoProfiles.length < 3) {
      context.showWarningFlush(message: "Select photo min 3 for your profile");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      title: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: context.width / 2,
        height: 5,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: indicatorProgres),
          duration: 500.ms,
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: secondaryColor.withOpacity(0.5),
              ),
            );
          },
        ),
      )
          .animate()
          .slide(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 200),
          )
          .fade(),
    );

    return BlocListener<MasterDataCubit, MasterDataState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          showLoading(context);
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: AnimatedContainer(
          duration: 2.seconds,
          width: context.width,
          height: context.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [linearColor, whiteColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: appBar.preferredSize.height),
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: pages,
                    ),
                    Positioned(
                      bottom: 20 + context.padBot,
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
                            child: const Icon(CupertinoIcons.back,
                                color: blackColor),
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
                      bottom: 20 + context.padBot,
                      child: GradientButton(
                        width: pageIndex > 0 ? 100 : null,
                        gradient: LinearGradient(
                          colors: [primaryColor, darkColor],
                        ),
                        onPressed: onNext,
                        child: Text(
                          "Next",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ).animate().fade(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(seconds: 1),
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
