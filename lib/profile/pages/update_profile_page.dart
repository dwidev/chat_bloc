import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/photos_picker/photos_widget.dart';
import '../../core/theme/colors.dart';
import '../../homepage/pages/home_page.dart';
import '../../nearbypeople/pages/nearby_people_card_detail_view.dart';
import 'preview_profile_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Update Profile",
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight - 15),
          child: InkWell(
            onTap: () {
              print("PREVIEW");
              push(context: context, page: const PreviewProfilePage());
            },
            child: Container(
              width: double.infinity,
              height: kToolbarHeight - 15,
              decoration: BoxDecoration(color: darkColor.withOpacity(0.04)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Preview",
                    style: textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PHOTOS",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const PhotosPickerWidget(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      "About Me",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    color: darkColor.withOpacity(0.04),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Describe About me...",
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.location),
                        const SizedBox(width: 5),
                        Text(
                          "My Location",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: darkColor.withOpacity(0.04),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onTapOutside: (event) {
                        print("ANJAU");
                      },
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: "Add Location",
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                  const DropdownLoversWidget(
                    title: "Gender",
                    hintText: "Gender",
                    icon: CupertinoIcons.resize_v,
                  ),
                  const DropdownLoversWidget(
                    title: "Height",
                    hintText: "Height...",
                    icon: CupertinoIcons.resize_v,
                  ),
                  const DropdownLoversWidget(
                    title: "Weight",
                    hintText: "Weight...",
                    icon: CupertinoIcons.resize_h,
                  ),
                  const DropdownLoversWidget(
                    title: "More About me",
                    hintText: "Zodiac",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Blood Type",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Education",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Personality type",
                    icon: CupertinoIcons.hare,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(CupertinoIcons.burst),
                            const SizedBox(width: 5),
                            Text(
                              "Interesting",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            print("CHANGE");
                          },
                          child: Row(
                            children: [
                              Text(
                                "Change",
                                style: textTheme.bodySmall?.copyWith(
                                  color: primaryColor,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                CupertinoIcons.arrow_2_circlepath,
                                size: 10,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(bottom: 20),
                    child: const InterstingWidget(),
                  ),
                  const DropdownLoversWidget(
                    title: "Im Looking for...",
                    hintText: "Looking for",
                    icon: CupertinoIcons.heart,
                  ),
                  const DropdownLoversWidget(
                    title: "My Love langguage",
                    hintText: "Love langguages",
                    icon: CupertinoIcons.heart_circle_fill,
                  ),
                  const DropdownLoversWidget(
                    title: "Lifestyle",
                    hintText: "Pets",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Social media activity",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Workout",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Smoking",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Drinking",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Sleeping habbits",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "Me on routine",
                    hintText: "My Weekend",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "My Hangouts",
                    icon: CupertinoIcons.hare,
                  ),
                  const DropdownLoversWidget(
                    title: "",
                    hintText: "Morning routine",
                    icon: CupertinoIcons.hare,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Personality settings",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: darkColor.withOpacity(0.04),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Don't show my age",
                              style:
                                  textTheme.bodySmall?.copyWith(fontSize: 13),
                            ),
                            Switch(
                              value: false,
                              onChanged: (value) {},
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: darkColor.withOpacity(0.04),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Don't show my distance",
                              style:
                                  textTheme.bodySmall?.copyWith(fontSize: 13),
                            ),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
            // Positioned(
            //   right: 0,
            //   left: 0,
            //   bottom: 30,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       child: const Text("Save"),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class DropdownLoversWidget extends StatelessWidget {
  const DropdownLoversWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.icon,
  });

  final String title;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (hintText.isNotEmpty)
          Container(
            color: darkColor.withOpacity(0.04),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      hintText,
                      style: textTheme.bodySmall?.copyWith(fontSize: 13),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    print("CHANGE");
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add",
                        style: textTheme.bodySmall?.copyWith(
                          color: primaryColor,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        CupertinoIcons.add,
                        size: 10,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
