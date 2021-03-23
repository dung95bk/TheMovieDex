import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class GuideProvider extends ChangeNotifier {
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = true;
  List<GuideModelDomain> guideList = List<GuideModelDomain>();

  GuideProvider() {

  }

  void getGuide() async {
    if(guideList.isNotEmpty) return;
    guideList.clear();
    GetGuideRequest getGuideRequest =
    GetGuideRequest.fromData(
        currentPageIndex, take, "000000000000000000000000");
    Response response;
    try {
      response = await Http.instance.getGuide(getGuideRequest);
      print("${response.data}");
      if (response != null && response.statusCode == 200) {
        GetGuideResponse getTokenResponse =
        GetGuideResponse().fromJson(response.data);
        var listData = getTokenResponse.data;
        listData.forEach((element) {
          guideList.add(GuideModelDomain.fromData(id: element.id,
              description: element.description,
              name: element.name,
              parentId: element.parentId,
              slug: element.slug,
              thumbnailUrl: element.thumbnailUrl));
          });
        print("data: ${guideList.length}");
        notifyListeners();
      }
    } catch (e) {}
  }

  void initData() {
    getGuide();
  }
}