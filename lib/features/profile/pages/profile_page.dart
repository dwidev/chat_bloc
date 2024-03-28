// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:matchloves/features/profile/pages/update_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:matchloves/core/theme/colors.dart';
import 'package:matchloves/features/main/pages/main_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static const path = '/profile';
}

class RemainingsActions {
  final String title;
  final int remainingsItem;
  final IconData icon;
  final Color iconColor;
  final List<Color> colors;

  RemainingsActions({
    required this.title,
    required this.remainingsItem,
    required this.icon,
    required this.iconColor,
    required this.colors,
  });

  static List<RemainingsActions> get data => [
        RemainingsActions(
          title: "Undo Cards",
          remainingsItem: 10,
          icon: CupertinoIcons.refresh_bold,
          iconColor: whiteColor,
          colors: [softblueColor, blueLightColor],
        ),
        RemainingsActions(
          title: "Like",
          remainingsItem: 100,
          icon: CupertinoIcons.heart_fill,
          iconColor: whiteColor,
          colors: [primaryColor, softyellowColor],
        ),
        RemainingsActions(
          title: "Bost Me",
          remainingsItem: 1,
          icon: CupertinoIcons.rocket_fill,
          iconColor: whiteColor,
          colors: [const Color(0xff1F4172), const Color(0xff132043)],
        ),
      ];
}

class _ProfilePageState extends State<ProfilePage> {
  late PageController pageController;
  double progressValue = 0.0;

  int curentPage = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          progressValue = 0.8;
        });
      });
    });
    pageController = PageController(initialPage: curentPage);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final bannerHeight = size.height / 2;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: darkLightColor,
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
                    top: top + 5,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: dummyUsers
                            .getRange(0, 4)
                            .toList()
                            .asMap()
                            .map((key, value) => MapEntry(
                                  key,
                                  Transform.translate(
                                    offset: key == 0
                                        ? Offset.zero
                                        : Offset(-key * 7, 0),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: whiteColor),
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            dummyUsers[key],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                      .animate()
                                      .slideX(
                                        end: 0,
                                        begin: (0.5 * (key + 0.5)).toDouble(),
                                      )
                                      .fade(
                                          // delay: const Duration(milliseconds: 500),
                                          ),
                                ))
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: top,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
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
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: darkColor.withOpacity(0.4),
                          ),
                          child: const Icon(
                            CupertinoIcons.settings,
                            color: whiteColor,
                            size: 20,
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
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(UpdateProfilePage.path);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.pencil,
                                    color: primaryColor,
                                    size: 25,
                                  ),
                                ),
                              ),
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
                                Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: darkLightColor.withOpacity(0.3),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.location_solid,
                                  color: whiteColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "Bogor, Indonesia",
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              height: 100,
                              decoration: BoxDecoration(
                                color: darkColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  PageView(
                                    controller: pageController,
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: (value) {
                                      setState(() {
                                        curentPage = value;
                                      });
                                    },
                                    children: const [
                                      ProfileRemainingBalanceWidget(),
                                      ProfileRemainingActionWidget(),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Transform.translate(
                                      offset: const Offset(11, -5),
                                      child: Column(
                                        children: [0, 1]
                                            .asMap()
                                            .map((key, value) => MapEntry(
                                                  key,
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: curentPage == key
                                                          ? primaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        2,
                                                      ),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                      bottom: 5,
                                                    ),
                                                    width: 5,
                                                    height: curentPage == key
                                                        ? 15
                                                        : 6,
                                                  ),
                                                ))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 300,
                child: PageView(
                  children: [0, 1, 2]
                      .map(
                        (e) => LayoutBuilder(
                          builder: (context, c) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              padding: const EdgeInsets.all(15),
                              width: size.width,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryColor, softyellowColor],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: blackColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        const WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Icon(
                                            CupertinoIcons.heart_circle_fill,
                                            size: 20,
                                          ),
                                        ),
                                        const TextSpan(text: "Lovers"),
                                        TextSpan(
                                          text: "Basic",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: blackColor,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: c.maxWidth / 1.5,
                                    child: Text(
                                      "Don't limit yourself to finding your true love",
                                      style: textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(2.5)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Text(
                                              "What's include",
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Free",
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Bacis",
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Text(
                                              "Undo cards",
                                              style: textTheme.bodySmall,
                                            ),
                                          ),
                                          Text(
                                            "-",
                                            style: textTheme.bodySmall,
                                          ),
                                          Text(
                                            "5/weeks",
                                            style: textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Text(
                                              "Like cards",
                                              style: textTheme.bodySmall,
                                            ),
                                          ),
                                          Text(
                                            "-",
                                            style: textTheme.bodySmall,
                                          ),
                                          Text(
                                            "5/weeks",
                                            style: textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Text(
                                              "Boost profile",
                                              style: textTheme.bodySmall,
                                            ),
                                          ),
                                          Text(
                                            "-",
                                            style: textTheme.bodySmall,
                                          ),
                                          Text(
                                            "1 (15min)/weeks",
                                            style: textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "See all benefite",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: const LinearGradient(
                                              colors: [
                                                blackColor,
                                                primaryColor,
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            "Subscribe",
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileRemainingActionWidget extends StatelessWidget {
  const ProfileRemainingActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: RemainingsActions.data
          .asMap()
          .map(
            (key, e) => MapEntry(
              e,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        e.remainingsItem.toString(),
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: e.colors,
                          ),
                        ),
                        child: Icon(
                          e.icon,
                          color: e.iconColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e.title,
                    style: textTheme.bodySmall?.copyWith(
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}

class ProfileRemainingBalanceWidget extends StatelessWidget {
  const ProfileRemainingBalanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.money_dollar_circle_fill,
                    color: Colors.white,
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Balance",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "10",
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: "coins",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.add,
                    color: whiteColor,
                    size: 20,
                  ),
                ),
                Text(
                  "Buy Coins",
                  style: textTheme.labelSmall?.copyWith(
                    color: whiteColor,
                    fontSize: 10,
                  ),
                )
              ],
            ),
            const SizedBox(width: 25),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.doc_plaintext,
                    color: whiteColor,
                    size: 20,
                  ),
                ),
                Text(
                  "History",
                  style: textTheme.labelSmall?.copyWith(
                    color: whiteColor,
                    fontSize: 10,
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
