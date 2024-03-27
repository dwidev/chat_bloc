part of 'photo_picker_cubit.dart';

@immutable
class PhotoPickerState extends Equatable {
  final int currentPage, totalPage;
  final List<AssetPathEntity> assets;
  final List<AssetEntity> photos;

  final AssetEntity? pickedPhoto;
  final List<MemoryImage> selectedPhotos;

  final bool isLoading;
  final bool isLoadMore;

  final PhotoViewEnum viewPhotoStatus;

  bool get noLoadMore => currentPage == totalPage;

  const PhotoPickerState({
    this.currentPage = 0,
    this.totalPage = 0,
    this.assets = const [],
    this.photos = const [],
    this.pickedPhoto,
    this.selectedPhotos = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.viewPhotoStatus = PhotoViewEnum.normal,
  });

  PhotoPickerState copyWith({
    int? currentPage,
    int? totalPage,
    List<AssetPathEntity>? assets,
    List<AssetEntity>? photos,
    ValueGetter<AssetEntity?>? pickedPhoto,
    List<MemoryImage>? selectedPhotos,
    bool? isLoading,
    bool? isLoadMore,
    PhotoViewEnum? viewPhotoStatus,
  }) {
    return PhotoPickerState(
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      assets: assets ?? this.assets,
      photos: photos ?? this.photos,
      pickedPhoto: pickedPhoto != null ? pickedPhoto.call() : this.pickedPhoto,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      viewPhotoStatus: viewPhotoStatus ?? this.viewPhotoStatus,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPage,
        assets,
        photos,
        pickedPhoto,
        selectedPhotos,
        isLoading,
        isLoadMore,
        viewPhotoStatus,
      ];
}

class PhotoPickerInitial extends PhotoPickerState {
  const PhotoPickerInitial(List<MemoryImage> images)
      : super(selectedPhotos: images);
}

class PhotoPickerSelected extends PhotoPickerState {
  const PhotoPickerSelected({
    required List<MemoryImage> selectedPhotos,
    List<AssetEntity> photos = const [],
    bool isLoading = false,
  }) : super(
          photos: photos,
          selectedPhotos: selectedPhotos,
          isLoading: isLoading,
        );
}
