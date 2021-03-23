import 'dart:ui';

import 'package:random_color/random_color.dart';

class CategoyModelDomain {
  bool isFav = false;
  String id;
  String name;
  String slug;
  String thumbnailUrl;
  Color randomColor = RandomColor().randomColor();

  CategoyModelDomain();

  CategoyModelDomain.fromData(
      this.isFav, this.id, this.name, this.slug, this.thumbnailUrl);
}