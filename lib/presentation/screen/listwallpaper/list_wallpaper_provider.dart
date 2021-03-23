import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/model/mapper/image_model_mapper.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_list_image_request.dart';
import 'package:themoviedex/data/remote/response/get_hot_response_entity.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:hive/hive.dart';

class ListWallpaperProvider extends ChangeNotifier {
  List<ImageModelDomain> listImage = List<ImageModelDomain>();
  ScrollController controller = ScrollController();
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = true;

  listener() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!loadingMore) {
          paginate();
          // Animate to bottom of list
          Timer(Duration(milliseconds: 100), () {
            controller.animateTo(
              controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          });
        }
      }
    });
  }

  void getListImage() async {
    loadingMore = true;
    GetListImageRequest getListImageRequest =
        GetListImageRequest.fromData(currentPageIndex, take);
    Response response;
    try {
      response = await Http.instance.getListImage(getListImageRequest);
    } catch (e) {}
    if (response != null && response.statusCode == 200) {
      GetHotResponse getTokenResponse =
          GetHotResponse().fromJson(response.data);
      var listData = getTokenResponse.data;
      print("Lenght hot image ${listData.length}");
      if (listData.length > 0) {
        allowLoadMore = true;
      } else {
        allowLoadMore = false;
      }

      listData.forEach((element) {
        listImage.add(ImageModelDomain.fromData(
            false,
            element.id,
            element.name,
            element.sourceUrl,
            element.mediumUrl,
            element.largeUrl,
            element.thumbnailUrl));
      });
      notifyListeners();
    } else {
      allowLoadMore = false;
    }

    loadingMore = false;
  }

  void firstCallData() {
    if (listImage.length == 0 && !loadingMore) {
      getListImage();
    }
  }

  void paginate() {
    if (allowLoadMore && !loadingMore) {
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      currentPageIndex = currentPageIndex + 1;
      notifyListeners();
      getListImage();
    }
  }

  Future<void> reset() async {
    currentPageIndex = 1;
    take = 20;
    loadingMore = false;
    allowLoadMore = true;
    listImage.clear();
    await getListImage();
  }

  void favorite(ImageModelDomain image) {
    image.isFav = !image.isFav;
    var boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    var foundImage = boxImage.get(image.id);
    if(foundImage == null) {
      boxImage.put(image.id, ImageModelMapper.toHiveObject(image));
      print("null");
    } else {
      foundImage.delete();
    }
  }
}
