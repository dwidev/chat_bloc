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

  @override
  void initState() {
    cropController = CustomImageCropController();
    final photoPickerCubit = context.read<PhotoPickerCubit>();
    photoPickerCubit.loadGalleryImages();
    super.initState();
  }

  @override
  dispose() {
    cropController.dispose();
    super.dispose();
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
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: state.photos.length,
                  itemBuilder: (context, index) {
                    final photo = state.photos[index];

                    return Stack(
                      fit: StackFit.loose,
                      children: [
                        InkWell(
                          onTap: () {
                            cropController.reset();
                            photoPickerCubit.onPickImageAtGalleryView(photo);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: whiteColor),
                              image: DecorationImage(
                                image: AssetEntityImageProvider(
                                  photo,
                                  thumbnailSize:
                                      const ThumbnailSize.square(100),
                                  thumbnailFormat: ThumbnailFormat.jpeg,
                                ),
                                fit: BoxFit.cover,
                              ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
