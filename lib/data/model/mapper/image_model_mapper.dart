import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';

class ImageModelMapper {
  static ImageModeHive toHiveObject(ImageModelDomain imageModelDomain) {
    return ImageModeHive(
        imageModelDomain.isFav,
        imageModelDomain.id,
        imageModelDomain.name,
        imageModelDomain.sourceUrl,
        imageModelDomain.mediumUrl,
        imageModelDomain.largeUrl,
        imageModelDomain.thumbnailUrl);
  }
}
