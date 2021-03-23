import 'package:hive/hive.dart';
part 'image_model_hive.g.dart';

@HiveType(typeId: 0)
class ImageModeHive extends HiveObject {
  @HiveField(0)
  bool isFav = false;
  @HiveField(1)
  String id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String sourceUrl;
  @HiveField(4)
  String mediumUrl;
  @HiveField(5)
  String largeUrl;
  @HiveField(6)
  String thumbnailUrl;

  ImageModeHive(this.isFav, this.id, this.name, this.sourceUrl, this.mediumUrl,
      this.largeUrl, this.thumbnailUrl);
}