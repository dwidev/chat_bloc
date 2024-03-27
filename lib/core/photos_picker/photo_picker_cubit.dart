import 'dart:async';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../depedency_injection/auto_reseting_singleton.dart';
import '../enums/photo_view_enum.dart';

part 'photo_picker_state.dart';

@LazySingleton()
class PhotoPickerCubit extends Cubit<PhotoPickerState>
    with AutoResetLazySingletonBloc<PhotoPickerCubit, PhotoPickerState> {
  PhotoPickerCubit() : super(const PhotoPickerInitial([])) {
    debugPrint("INITIALIZE $PhotoPickerCubit");
  }

  void resetState() {
    emit(const PhotoPickerInitial([]));
  }

  @disposeMethod
  void dispose() {
    debugPrint("DISPOSE $PhotoPickerCubit");
  }

  void initialize(List<MemoryImage> images) {
    emit(PhotoPickerInitial(images));
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
