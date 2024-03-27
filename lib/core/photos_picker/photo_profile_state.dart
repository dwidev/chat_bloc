import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

@immutable
class PhotoProfileState extends Equatable {
  final List<AssetEntity> pickedImages;

  const PhotoProfileState({required this.pickedImages});

  @override
  List<Object?> get props => [];
}
