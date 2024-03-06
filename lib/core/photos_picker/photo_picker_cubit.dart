// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
        hasAll: true,
      );

      if (assets.isNotEmpty) {
        final photos = await assets.first.getAssetListPaged(page: 0, size: 50);
        emit(state.copyWith(photos: photos));
      }
    }
  }

  void onPickImageAtGalleryView(AssetEntity? pickedPhoto) {
    if (state.pickedPhoto == pickedPhoto) {
      emit(state.copyWith(pickedPhoto: () => null));
      return;
    }

    emit(state.copyWith(pickedPhoto: () => pickedPhoto));
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
}

@immutable
class PhotoPickerState extends Equatable {
  final List<AssetEntity> photos;
  final AssetEntity? pickedPhoto;
  final List<MemoryImage> selectedPhotos;
  final bool isLoading;

  const PhotoPickerState({
    this.photos = const [],
    this.pickedPhoto,
    this.selectedPhotos = const [],
    this.isLoading = false,
  });

  PhotoPickerState copyWith({
    List<AssetEntity>? photos,
    ValueGetter<AssetEntity?>? pickedPhoto,
    List<MemoryImage>? selectedPhotos,
    bool? isLoading,
  }) {
    return PhotoPickerState(
      photos: photos ?? this.photos,
      pickedPhoto: pickedPhoto != null ? pickedPhoto.call() : this.pickedPhoto,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [photos, pickedPhoto, selectedPhotos, isLoading];
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
