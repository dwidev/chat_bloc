// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    final photoPickerCubit = context.read<PhotoPickerCubit>();
    photoPickerCubit.loadGalleryImages();
    scrollController = ScrollController()..addListener(onLoadMore);
    super.initState();
  }

  @override
  dispose() {
    cropController.dispose();
    super.dispose();
  }

  void onLoadMore() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      context.read<PhotoPickerCubit>().loadMoreImage();
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
            Container(
              padding: EdgeInsets.zero,
              width: context.width,
              height: context.height / 3,
              child: CustomImageCrop(
                canRotate: false,
                drawPath: (path, {pathPaint}) {
                  return DottedCropPathPainter.drawPath(
                    path,
                    pathPaint: Paint()
                      ..color = darkColor
                      ..strokeWidth = 1.0
                      ..style = PaintingStyle.stroke
                      ..strokeJoin = StrokeJoin.round,
                  );
                },
                cropController: cropController,
                imageFit: CustomImageFit.fillVisibleHeight,
                image: AssetEntityImageProvider(
                  pickedPhoto,
                  thumbnailSize: const ThumbnailSize.square(100),
                ),
                overlayColor: Colors.white.withOpacity(0.5),
                ratio: Ratio(width: 9, height: 16),
                shape: CustomCropShape.Square,
              ),
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
                return GridView.custom(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              photoPickerCubit.onPickImageAtGalleryView(photo);
                            },
                            child: Container(
                              width: context.width / 2,
                              height: context.width / 2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: whiteColor,
                                ),
                                color: darkLightColor,
                              ),
                              child: AssetEntityImage(
                                photo,
                                thumbnailSize: const ThumbnailSize.square(500),
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
                                  print(value);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
