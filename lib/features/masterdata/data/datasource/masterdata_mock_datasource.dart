import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/environtments/flavors.dart';
import '../model/mastedata_model.dart';
import '../model/master_interest_model.dart';
import 'masterdata_datasource.dart';

@Environment(envMockString)
@LazySingleton(as: MasterDataDasource)
class MasterDataMockDataSourceImpl implements MasterDataDasource {
  @override
  Future<List<MasterDataInterestModel>> getListInterests() async {
    await Future.delayed(1.seconds);
    final data = [
      {
        "name": "Traveling",
        "icon": CupertinoIcons.airplane.codePoint,
        "code": "TRAVELING"
      },
      {
        "name": "Foodie",
        "icon": Icons.local_dining.codePoint,
        "code": "FOODIE"
      },
      {
        "name": "Outdoor Adventures",
        "icon": CupertinoIcons.tree.codePoint,
        "code": "OUTDOOR_ADVENTURES"
      },
      {
        "name": "Fitness",
        "icon": CupertinoIcons.bolt.codePoint,
        "code": "FITNESS"
      },
      {
        "name": "Movies",
        "icon": CupertinoIcons.film.codePoint,
        "code": "MOVIES"
      },
      {
        "name": "Music/Spotify",
        "icon": CupertinoIcons.music_note.codePoint,
        "code": "MUSIC_SPOTIFY"
      },
      {
        "name": "Art",
        "icon": CupertinoIcons.paintbrush.codePoint,
        "code": "ART"
      },
      {
        "name": "Reading",
        "icon": CupertinoIcons.book.codePoint,
        "code": "READING"
      },
      {
        "name": "Gaming",
        "icon": CupertinoIcons.game_controller.codePoint,
        "code": "GAMING"
      },
      {
        "name": "Technology",
        "icon": CupertinoIcons.device_laptop.codePoint,
        "code": "TECHNOLOGY"
      },
      {
        "name": "Fashion",
        "icon": CupertinoIcons.star.codePoint,
        "code": "FASHION"
      },
      {
        "name": "Cooking",
        "icon": Icons.restaurant_rounded.codePoint,
        "code": "COOKING"
      },
      {
        "name": "Sports",
        "icon": CupertinoIcons.sportscourt.codePoint,
        "code": "SPORTS"
      }
    ];

    final response =
        data.map((e) => MasterDataInterestModel.fromMap(e)).toList();
    return Future.value(response);
  }

  @override
  Future<List<MasterDataModel>> getListLookingFor() async {
    await Future.delayed(1.seconds);
    final data = [
      {"code": "LT_PARTNER", "name": "A long-term partner 🥰💘"},
      {"code": "LOOKING_FRIENDS", "name": "Looking for friends 👋🏻🤙🏻"},
      {
        "code": "LOOKING_SIBLING",
        "name": "Looking for a brother or sister 🙋🏻‍♂️🙋🏻‍♀️"
      },
      {"code": "FIGURING_IT_OUT", "name": "Still figuring it out 🤔"}
    ];

    final response = data.map((e) => MasterDataModel.fromMap(e)).toList();
    return Future.value(response);
  }

  @override
  @disposeMethod
  void dispose() {
    debugPrint("$this disposed");
  }
}
