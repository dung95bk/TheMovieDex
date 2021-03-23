import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/model/mapper/image_model_mapper.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:hive/hive.dart';

class FavoritedProvider extends ChangeNotifier {
  List<ImageModelDomain> listImage = List<ImageModelDomain>();
  ScrollController controller = ScrollController();

  FavoritedProvider(){
    getListImage();
  }

  void getListImage() {
    var boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    boxImage.values.forEach((element) {
      listImage.add(ImageModelDomain.fromHive(element));
    });
    notifyListeners();
  }

  void favorite(ImageModelDomain image) {
    image.isFav = !image.isFav;
    var boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    var foundImage = boxImage.get(image.id);
    if(foundImage == null) {
      boxImage.put(image.id, ImageModelMapper.toHiveObject(image));
    } else {
      foundImage.delete();
    }
  }
}
