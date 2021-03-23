import 'dart:collection';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class AbilitiesPageProvider extends ChangeNotifier {
  Map<GuideModelDomain, List<GuideModelDomain>> listAbilities =
      HashMap<GuideModelDomain, List<GuideModelDomain>>();
  GuideModelDomain currentType = null;
  GuideModelDomain abilitiesData;
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = false;
  ScrollController controller = ScrollController();
  List<GuideModelDomain> category = List<GuideModelDomain>();
  int tabIndex = 0;
  initData({GuideModelDomain abilitiesData}) {
    this.abilitiesData = abilitiesData;
    if (listAbilities.length == 0) {
      getCategoryAbilities();
    }
  }

  void expandItem(GuideModelDomain mapModel) {
    listAbilities.forEach((GuideModelDomain key, List<GuideModelDomain> value) {
      value.forEach((element) {
        if (identical(element, mapModel)) {
          element.isExpanded = true;
        }
      });
    });
    notifyListeners();
  }

  void colapseItem(GuideModelDomain mapModel) {
    listAbilities.forEach((GuideModelDomain key, List<GuideModelDomain> value) {
      value.forEach((element) {
        if (identical(element, mapModel)) {
          element.isExpanded = false;
        }
      });
    });
    notifyListeners();
  }

  List<String> getTabName() {
    return listAbilities.keys.toList().map((e) => e.name).toList();
  }

  List<GuideModelDomain> getTabData() {
    if(currentType == null) {
      return List<GuideModelDomain>();
    }
    return listAbilities[currentType];
  }

  changePage(int index) {
    tabIndex = index;
    currentType = category[index];
    if (listAbilities[currentType].length == 0) {
      getDetailCategoriesAbilities(currentType);
    } else {
      notifyListeners();
    }
  }

  void getCategoryAbilities() async {
    GetGuideRequest getGuideRequest =
        GetGuideRequest.fromData(currentPageIndex, take, abilitiesData.id);
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
      print("${response.data}");
      list.forEach((element) {
        var itemCategory = GuideModelDomain.fromData(
            id: element.id,
            description: element.description,
            name: element.name,
            parentId: element.parentId,
            slug: element.slug,
            thumbnailUrl: element.thumbnailUrl);
        print("isLeft : ${ itemCategory.isLeft}");
        category.add(itemCategory);
        listAbilities[itemCategory] = List<GuideModelDomain>();
      });
      print("category abilities: ${listAbilities.length}");
      if (category.length > 0) {
        currentType = category[0];
        getDetailCategoriesAbilities(currentType);
      }
    }
  }

  void getDetailCategoriesAbilities(GuideModelDomain guideModelDomain) async {
    GetGuideRequest getGuideRequest =
        GetGuideRequest.fromData(currentPageIndex, take, guideModelDomain.id);
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
        int index = -1;
        list.forEach((element) {
          index += 1;
          var itemCategory = GuideModelDomain.fromData(
              id: element.id,
              description: element.description,
              name: element.name,
              parentId: element.parentId,
              slug: element.slug,
              thumbnailUrl: element.thumbnailUrl);
          listAbilities[guideModelDomain].add(itemCategory);
          itemCategory.isLeft = index.isOdd;

        });
        notifyListeners();
      } else {
        allowLoadMore = false;
      }
    }
  }
}
