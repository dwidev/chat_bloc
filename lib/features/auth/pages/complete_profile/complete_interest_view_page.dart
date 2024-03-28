import 'package:matchloves/core/extensions/extensions.dart';
import 'package:matchloves/core/theme/colors.dart';
import 'package:matchloves/features/auth/bloc/complete_profile_bloc.dart';
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteInterstViewPage extends StatefulWidget {
  const CompleteInterstViewPage({
    super.key,
  });

  @override
  State<CompleteInterstViewPage> createState() =>
      _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteInterstViewPage> {
  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();
    final masterData = context.read<MasterDataCubit>();

    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "I'm Interest for...",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        SizedBox(
          width: context.width / 1.2,
          child: Text(
            "Provide us with further insights into your interesting",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (context, state) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: masterData.state.interests
                    .asMap()
                    .map((key, e) {
                      final code = e.code;
                      final name = e.name;
                      final icon = IconData(e.icon);
                      final isSelect = state.interests.selected(code);
                      return MapEntry(
                        key,
                        InkWell(
                          onTap: () {
                            completeBloc.add(
                              CompleteProfileSetInterestEvent(code: code),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isSelect ? primaryColor : whiteColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelect ? whiteColor : primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  name,
                                  style: textTheme.bodyMedium?.copyWith(
                                      color: isSelect ? whiteColor : darkColor),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fade(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(seconds: 1),
                              )
                              .slide(
                                begin: Offset(0, key + 2),
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn,
                              ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
