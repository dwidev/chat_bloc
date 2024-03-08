import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPickerCubit extends Cubit<PhotoPickerState> {
  PhotoPickerCubit() : super(const PhotoPickerInitial());

  void resetState() {
    emit(const PhotoPickerInitial());
  }

  MemoryImage? getImage(int index) {
    if (state.selectedPhotos.isEmpty ||
        state.selectedPhotos.length < (index + 1)) {
      return null;
    }

    final image = state.selectedPhotos[index];
    return image;
  }

  void deleteImage(int index) {
    final images = state.selectedPhotos.toList();
    images.removeAt(index);
    emit(state.copyWith(selectedPhotos: images));
  }

  Future<void> loadGalleryImages() async {
    final ps = await PhotoManager.requestPermissionExtend();
    if (ps.hasAccess) {
      final assets = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      final count = await assets.first.assetCountAsync;
      final totalPage = (count / 50).ceil();

      if (assets.isNotEmpty) {
        final photos = await assets.first.getAssetListPaged(page: 0, size: 50);
        final newState = state.copyWith(
          photos: photos,
          assets: assets,
          currentPage: 0,
          totalPage: totalPage,
        );
        emit(newState);
      }
    }
  }

  Future<void> loadMoreImage() async {
    if (state.isLoadMore || state.noLoadMore) return;

    emit(state.copyWith(isLoadMore: true));

    final nextPage = state.currentPage + 1;
    final photos = await state.assets.first.getAssetListPaged(
      page: nextPage,
      size: 50,
    );

    final newPhotos = state.photos.toList();
    newPhotos.addAll(photos);

    final newState = state.copyWith(
      photos: newPhotos,
      currentPage: nextPage,
      isLoadMore: false,
    );

    emit(newState);
  }

  void onPickImageAtGalleryView(AssetEntity? pickedPhoto) {
    if (state.pickedPhoto == pickedPhoto) {
      emit(state.copyWith(pickedPhoto: () => null));
      return;
    }

    emit(state.copyWith(
      pickedPhoto: () => pickedPhoto,
      viewPhotoStatus: PhotoViewEnum.normal,
    ));
  }

  Future<void> onSaveSelectedPhotos(
    CustomImageCropController cropController,
  ) async {
    final pickedPhoto = state.pickedPhoto;
    if (pickedPhoto == null) return;

    emit(state.copyWith(isLoading: true));
    final croped = await cropController.onCropImage();
    final selectedPhotos = state.selectedPhotos.toList();
    selectedPhotos.add(croped!);
    emit(PhotoPickerSelected(selectedPhotos: selectedPhotos));
  }

  Future<void> onChangePhoto(
    CustomImageCropController cropController,
    int index,
  ) async {
    final pickedPhoto = state.pickedPhoto;
    if (pickedPhoto == null) return;

    emit(state.copyWith(isLoading: true));

    final images = state.selectedPhotos.toList();

    final croped = await cropController.onCropImage();
    images.replaceRange(index, index + 1, [croped!]);
    emit(PhotoPickerSelected(selectedPhotos: images));
  }

  void changeViewPhoto() {
    if (state.viewPhotoStatus.isFullScreen) {
      emit(state.copyWith(viewPhotoStatus: PhotoViewEnum.normal));
    } else {
      emit(state.copyWith(viewPhotoStatus: PhotoViewEnum.fullScreen));
    }
  }
}

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
  const PhotoPickerInitial();
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
