import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../depedency_injection/injection.dart';
import '../dialog/delete_alert_dialog.dart';
import '../dialog/loading_dialog.dart';
import '../dialog/show_image_dialog.dart';
import '../enums/photo_view_enum.dart';
import '../extensions/extensions.dart';
import '../theme/colors.dart';
import '../widget/circle_icon_button.dart';
import 'photo_picker_cubit.dart';

part 'gallery_view_page.dart';

class PhotosPickerWidget extends StatelessWidget {
  const PhotosPickerWidget({
    Key? key,
    this.backgroundColor,
    this.dashColor,
    this.initialImages = const [],
    this.onSelectedImage,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? dashColor;
  final List<MemoryImage> initialImages;
  final Function(List<MemoryImage> images)? onSelectedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotoPickerCubit>(
      create: (_) => getIt<PhotoPickerCubit>(),
      child: PhotosPickerWidgetContent(
        backgroundColor: backgroundColor,
        dashColor: dashColor,
        initialImages: initialImages,
        onSelectedImage: onSelectedImage,
      ),
    );
  }
}

class PhotosPickerWidgetContent extends StatefulWidget {
  const PhotosPickerWidgetContent({
    super.key,
    this.backgroundColor,
    this.dashColor,
    this.initialImages = const [],
    this.onSelectedImage,
  });

  final Color? backgroundColor;
  final Color? dashColor;
  final List<MemoryImage> initialImages;
  final Function(List<MemoryImage> images)? onSelectedImage;

  @override
  State<PhotosPickerWidgetContent> createState() =>
      _PhotosPickerWidgetContentState();
}

class _PhotosPickerWidgetContentState extends State<PhotosPickerWidgetContent> {
  late PhotoPickerCubit photoPickerCubit;

  @override
  void initState() {
    photoPickerCubit = context.read<PhotoPickerCubit>();
    photoPickerCubit.initialize(widget.initialImages);
    super.initState();
  }

  void goToGalleryView(int? index) {
    photoPickerCubit.onPickImageAtGalleryView(null);
    context.push(GalleryViewPage.path, extra: index);
  }

  void onDelete(int index) {
    showDeleteAlertDialog(
      context: context,
      onDelete: () {
        context.pop();
        photoPickerCubit.deleteImage(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<PhotoPickerCubit, PhotoPickerState>(
      listener: (context, state) {
        if (state is PhotoPickerSelected) {
          widget.onSelectedImage?.call(state.selectedPhotos);
        }
      },
      builder: (context, state) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (_, index) {
            if (photoPickerCubit.getImage(index) != null) {
              return Stack(
                children: [
                  InkWell(
                    onDoubleTap: () {
                      showImageDialog(
                        context: context,
                        image: MemoryImage(
                          state.selectedPhotos[index].bytes,
                        ),
                      );
                    },
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        title: const Text('Action photo'),
                        androidBorderRadius: 30,
                        actions: <BottomSheetAction>[
                          BottomSheetAction(
                            title: Text(
                              'Delete',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            onPressed: (context) {
                              context.pop();
                              onDelete(index);
                            },
                          ),
                          BottomSheetAction(
                            title: Text(
                              'Change',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: Colors.lightBlue,
                              ),
                            ),
                            onPressed: (context) {
                              context.pop();
                              goToGalleryView(index);
                            },
                          ),
                          BottomSheetAction(
                            title: Text(
                              'View',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: Colors.lightBlue,
                              ),
                            ),
                            onPressed: (context) {
                              context.pop();
                              showImageDialog(
                                context: context,
                                image: MemoryImage(
                                  state.selectedPhotos[index].bytes,
                                ),
                              );
                            },
                          ),
                        ],
                        cancelAction: CancelAction(
                          title: Text(
                            'Cancel',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: darkColor,
                          image: DecorationImage(
                            image: MemoryImage(
                              state.selectedPhotos[index].bytes,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () => onDelete(index),
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
              onTap: () {
                goToGalleryView(null);
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: const [6, 3, 6, 3],
                padding: const EdgeInsets.all(2),
                radius: const Radius.circular(10),
                color: widget.dashColor ?? darkColor.withOpacity(0.3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          widget.backgroundColor ?? darkColor.withOpacity(0.04),
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
      },
    );
  }
}
