import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class ColorsPageProvider extends ChangeNotifier {
  List<GuideModelDomain> listColors = List<GuideModelDomain>();
  GuideModelDomain colorData;
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = false;
  ScrollController controller = ScrollController();

  initData(GuideModelDomain colorData) {
    this.colorData = colorData;
    if (listColors.length == 0) {
      getListColors();
    }
  }

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

  void firstCallData(GuideModelDomain colorData) {
    this.colorData = colorData;
    if (listColors.length == 0 && !loadingMore) {
      getListColors();
    }
  }

  void paginate() {
    if (allowLoadMore && !loadingMore) {
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      currentPageIndex = currentPageIndex + 1;
      notifyListeners();
      getListColors();
    }
  }

  Future<void> reset() async {
    currentPageIndex = 1;
    take = 20;
    loadingMore = false;
    allowLoadMore = true;
    listColors.clear();
    await getListColors();
  }

  void getListColors() async {
    loadingMore = true;
    GetGuideRequest getGuideRequest =
    GetGuideRequest.fromData(currentPageIndex, take, colorData.id);
    Response response;
    try {
      response = await Http.instance.getGuide(getGuideRequest);
      print("${response.data}");
    } catch (e) {}
    if (response != null && response.statusCode == 200) {
      GetGuideResponse getTokenResponse =
      GetGuideResponse().fromJson(response.data);
      var list = getTokenResponse.data;
      if (list.length > 0) {
        allowLoadMore = true;
      } else {
        allowLoadMore = false;
      }
      list.forEach((element) {
        listColors.add(GuideModelDomain.fromData(
            id: element.id,
            description: element.description,
            name: element.name,
            parentId: element.parentId,
            slug: element.slug,
            thumbnailUrl: element.thumbnailUrl));
      });
      print("data: ${listColors.length}");
      notifyListeners();
    } else {
      allowLoadMore = false;
    }

    loadingMore = false;
  }

}
