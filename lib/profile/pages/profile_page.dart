import 'dart:ui';

import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double progressValue = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          progressValue = 0.8;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final bannerHeight = size.height / 3.2;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Profile",
      //     style: textTheme.bodyLarge?.copyWith(
      //       fontWeight: FontWeight.bold,
      //       color: whiteColor,
      //     ),
      //   ),
      //   centerTitle: false,
      // ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: bannerHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://i.pinimg.com/736x/e0/55/2f/e0552fea9c9499a0388f96c95a996fc4.jpg",
                        ),
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: SizedBox(
                      width: size.width,
                      height: bannerHeight,
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: top,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: darkColor.withOpacity(0.4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.checkmark_seal_fill,
                                color: blueLightColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Verify Your Profile",
                                style: textTheme.bodySmall?.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: darkColor.withOpacity(0.4),
                          ),
                          child: const Icon(
                            CupertinoIcons.settings,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(dummyUsers[2]),
                                  radius: 45,
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    value: progressValue,
                                    color: primaryColor,
                                    backgroundColor: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(0, 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [primaryColor, softyellowColor],
                                  ),
                                ),
                                child: Text(
                                  "${(progressValue * 100).toInt()}%",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Michelle Zudith, 23",
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: blueLightColor,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
