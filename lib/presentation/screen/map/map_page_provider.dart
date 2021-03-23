import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class MapPageProvider extends ChangeNotifier {
  List<GuideModelDomain> listMap = List<GuideModelDomain>();
  GuideModelDomain mapData;
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = false;
  ScrollController controller = ScrollController();

  listener() {
    // controller.addListener(() {
    //   if (controller.position.pixels == controller.position.maxScrollExtent) {
    //     if (!loadingMore) {
    //       paginate();
    //       // Animate to bottom of list
    //       Timer(Duration(milliseconds: 100), () {
    //         controller.animateTo(
    //           controller.position.maxScrollExtent,
    //           duration: Duration(milliseconds: 100),
    //           curve: Curves.easeIn,
    //         );
    //       });
    //     }
    //   }
    // });
  }

  void firstCallData(GuideModelDomain mapData) {
    this.mapData = mapData;
    if (listMap.length == 0 && !loadingMore) {
      getListMap();
    }
  }

  void paginate() {
    if (allowLoadMore && !loadingMore) {
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      currentPageIndex = currentPageIndex + 1;
      notifyListeners();
      getListMap();
    }
  }

  Future<void> reset() async {
    currentPageIndex = 1;
    take = 20;
    loadingMore = false;
    allowLoadMore = true;
    listMap.clear();
    await getListMap();
  }

  void initData(GuideModelDomain mapData) {
    this.mapData = mapData;
    if (listMap.length == 0) {
      getListMap();
    }
  }

  void expandItem(ExpandableModel mapModel) {
    listMap.forEach((element) {
      if (identical(element, mapModel)) {
        element.isExpanded = true;
      }
    });
    notifyListeners();
  }

  void colapseItem(ExpandableModel mapModel) {
    listMap.forEach((element) {
      if (identical(element, mapModel)) {
        element.isExpanded = false;
      }
    });
    notifyListeners();
  }

  void getListMap() async {
    loadingMore = true;
    GetGuideRequest getGuideRequest =
        GetGuideRequest.fromData(currentPageIndex, take, mapData.id);
    Response response;
    try {
      response = await Http.instance.getGuide(getGuideRequest);
      print("${response.data}");
    } catch (e) {}
    if (response != null && response.statusCode == 200) {
      GetGuideResponse getTokenResponse =
          GetGuideResponse().fromJson(response.data);
      var listData = getTokenResponse.data;
      if (listData.length > 0) {
        allowLoadMore = true;
      } else {
        allowLoadMore = false;
      }
      listData.forEach((element) {
        listMap.add(GuideModelDomain.fromData(
            id: element.id,
            description: element.description,
            name: element.name,
            parentId: element.parentId,
            slug: element.slug,
            thumbnailUrl: element.thumbnailUrl));
      });
      print("data: ${listMap.length}");
      notifyListeners();
    } else {
      allowLoadMore = false;
    }

    loadingMore = false;
  }
}
