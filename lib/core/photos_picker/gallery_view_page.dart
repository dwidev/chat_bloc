part of 'photos_widget.dart';

class _GalleryViewPage extends StatelessWidget {
  final int? index;

  const _GalleryViewPage({
    Key? key,
    required this.index,
    required this.photoPickerCubit,
  }) : super(key: key);

  final PhotoPickerCubit photoPickerCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: photoPickerCubit,
      child: _GalleryViewPageContent(index),
    );
  }
}

class _GalleryViewPageContent extends StatefulWidget {
  final int? index;
  const _GalleryViewPageContent(this.index);

  @override
  State<_GalleryViewPageContent> createState() =>
      _GalleryViewPageContentState();
}

class _GalleryViewPageContentState extends State<_GalleryViewPageContent> {
  late CustomImageCropController cropController;
  late ScrollController scrollController;

  @override
  void initState() {
    cropController = CustomImageCropController();
    context.read<PhotoPickerCubit>().loadGalleryImages();
    scrollController = ScrollController()..addListener(onScrollListen);
    super.initState();
  }

  @override
  dispose() {
    scrollController.removeListener(onScrollListen);
    scrollController.dispose();
    cropController.dispose();
    super.dispose();
  }

  void onScrollListen() {
    final photoPickerCubit = context.read<PhotoPickerCubit>();
    final pixUnderNegative40 = scrollController.position.pixels < -40;
    final isTop = scrollController.position.pixels <=
        scrollController.position.minScrollExtent;
    final isNormal = photoPickerCubit.state.viewPhotoStatus.isNormal;
    final isFull = photoPickerCubit.state.viewPhotoStatus.isFullScreen;
    final isStartScroll = scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
    final isLoadMore =
        scrollController.offset >= scrollController.position.maxScrollExtent;

    if (pixUnderNegative40 && isTop && isNormal) {
      photoPickerCubit.changeViewPhoto();
    }

    if (isStartScroll && isFull) {
      photoPickerCubit.changeViewPhoto();
    }

    if (isLoadMore) {
      photoPickerCubit.loadMoreImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPickerCubit = context.read<PhotoPickerCubit>();
    final pickedPhoto = context.select<PhotoPickerCubit, AssetEntity?>(
      (value) => value.state.pickedPhoto,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select best photo",
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final index = widget.index;
              if (index != null) {
                photoPickerCubit.onChangePhoto(cropController, index);
                return;
              }

              photoPickerCubit.onSaveSelectedPhotos(cropController);
            },
            child: Text(widget.index != null ? "Change" : "Save"),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          if (pickedPhoto != null)
            CropedWidget(
              cropController: cropController,
              pickedPhoto: pickedPhoto,
            ),
          Expanded(
            child: BlocConsumer<PhotoPickerCubit, PhotoPickerState>(
              listenWhen: (previous, current) {
                if (previous.isLoading || previous.isLoading == false) {
                  return true;
                }

                return false;
              },
              listener: (context, state) {
                if (state.isLoading) {
                  showLoading(context);
                }

                if (state is PhotoPickerSelected) {
                  var c = 2;
                  Navigator.popUntil(context, (route) => c-- <= 0);
                }
              },
              builder: (context, state) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GridView.custom(
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final photo = state.photos[index];

                        return Stack(
                          key: ValueKey<int>(index),
                          fit: StackFit.loose,
                          children: [
                            InkWell(
                              onTap: () {
                                cropController.reset();
                                photoPickerCubit
                                    .onPickImageAtGalleryView(photo);
                              },
                              child: Container(
                                width: context.width / 4,
                                height: context.width / 4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: whiteColor,
                                  ),
                                  color: darkLightColor,
                                ),
                                child: AssetEntityImage(
                                  photo,
                                  thumbnailSize:
                                      const ThumbnailSize.square(500),
                                  isOriginal: false,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    }
                                    final double? value;
                                    if (progress.expectedTotalBytes != null) {
                                      value = progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!;
                                    } else {
                                      value = null;
                                    }

                                    return Center(
                                      child: SizedBox.fromSize(
                                        size: const Size.square(40),
                                        child: CircularProgressIndicator(
                                          value: value,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (pickedPhoto == photo)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      childCount: state.photos.length,
                      findChildIndexCallback: (Key key) {
                        // Re-use elements.
                        if (key is ValueKey<int>) {
                          return key.value;
                        }
                        return null;
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CropedWidget extends StatelessWidget {
  const CropedWidget({
    super.key,
    required this.cropController,
    required this.pickedPhoto,
  });

  final CustomImageCropController cropController;
  final AssetEntity pickedPhoto;

  @override
  Widget build(BuildContext context) {
    final photoPickerCubit = context.read<PhotoPickerCubit>();

    return BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
      buildWhen: (p, c) => p.viewPhotoStatus != c.viewPhotoStatus,
      builder: (context, state) {
        final height = switch (state.viewPhotoStatus) {
          PhotoViewEnum.fullScreen => context.height / 1.4,
          _ => (context.height / 5),
        };
        final borderRadius = switch (state.viewPhotoStatus) {
          PhotoViewEnum.fullScreen => 20.0,
          _ => 10.0,
        };
        final actionWidth = switch (state.viewPhotoStatus) {
          PhotoViewEnum.fullScreen => 50.0,
          _ => 30.0,
        };
        final iconSize = switch (state.viewPhotoStatus) {
          PhotoViewEnum.fullScreen => 25.0,
          _ => 15.0,
        };

        return GestureDetector(
          onPanStart: (details) {
            if (state.viewPhotoStatus.isNormal) {
              photoPickerCubit.changeViewPhoto();
            }
          },
          child: Stack(
            children: [
              AnimatedContainer(
                duration: 500.ms,
                curve: Curves.fastEaseInToSlowEaseOut,
                padding: EdgeInsets.zero,
                width: context.width,
                height: height.floorToDouble(),
                child: CustomImageCrop(
                  borderRadius: borderRadius,
                  cropPercentage: 0.95,
                  canRotate: false,
                  drawPath: (path, {pathPaint}) {
                    return DottedCropPathPainter.drawPath(
                      path,
                      pathPaint: Paint()
                        ..color = darkColor
                        ..strokeWidth = 0.5
                        ..style = PaintingStyle.stroke
                        ..strokeJoin = StrokeJoin.round,
                    );
                  },
                  cropController: cropController,
                  image: AssetEntityImageProvider(pickedPhoto),
                  overlayColor: Colors.white.withOpacity(0.5),
                  ratio: Ratio(width: 9, height: 16),
                  shape: CustomCropShape.Ratio,
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: CircleIconButton(
                  size: actionWidth,
                  onPressed: photoPickerCubit.changeViewPhoto,
                  iconSize: iconSize,
                  icon: state.viewPhotoStatus.icon,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
