import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/model/mapper/image_model_mapper.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_detail_category_request.dart';
import 'package:themoviedex/data/remote/response/get_category_detail_response_entity.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:hive/hive.dart';

class CategoryDetailProvider extends ChangeNotifier {
  List<ImageModelDomain> listImage = List<ImageModelDomain>();
  ScrollController controller = ScrollController();
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = true;
  String categoryId = "";
  String categoryName = "";

  CategoryDetailProvider(String categoryId) {
    firstCallData(categoryId);
    listener();
  }

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
    GetCategoryDetailRequest getListImageRequest =
        GetCategoryDetailRequest.fromData(currentPageIndex, take, categoryId);
    Response response;
    try {
      response = await Http.instance.getCategoryDetail(getListImageRequest);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode == 200) {
      GetCategoryDetailResponse getCategoryDetailResponse =
      GetCategoryDetailResponse().fromJson(response.data);
      categoryName = getCategoryDetailResponse.data.categoryName;
      var listData = getCategoryDetailResponse.data.images;

      if (listData.length >= take) {
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

  void firstCallData(String categoryId) {
    this.categoryId = categoryId;
    print("Detail Category ${listImage.length}");
    if (listImage.length == 0 && !loadingMore) {
      getListImage();
    }
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
}
