import 'dart:ui';

import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:random_color/random_color.dart';

class ImageModelDomain {
  bool isFav = false;
  String id;
  String name;
  String sourceUrl;
  String mediumUrl;
  String largeUrl;
  String thumbnailUrl;
  Color randomColor = RandomColor().randomColor();

  ImageModelDomain();

  ImageModelDomain.fromData(this.isFav, this.id, this.name, this.sourceUrl,
      this.mediumUrl, this.largeUrl, this.thumbnailUrl);

  ImageModelDomain.fromHive(ImageModeHive imageModeHive) {
    this.isFav = imageModeHive.isFav;
    this.id = imageModeHive.id;
    this.name = imageModeHive.name;
    this.mediumUrl = imageModeHive.mediumUrl;
    this.sourceUrl = imageModeHive.sourceUrl;
    this.largeUrl = imageModeHive.largeUrl;
    this.thumbnailUrl = imageModeHive.thumbnailUrl;
  }
}
