import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/model/local/task_model.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';

class TaskPageProvider extends ChangeNotifier {
  Map<GuideModelDomain, List<GuideModelDomain>> listTask =
      HashMap<GuideModelDomain, List<GuideModelDomain>>();
  GuideModelDomain currentType = null;
  GuideModelDomain taskData;
  int currentPageIndex = 1;
  int take = 20;
  bool loadingMore = false;
  bool allowLoadMore = false;
  ScrollController controller = ScrollController();
  List<GuideModelDomain> category = List<GuideModelDomain>();
  int tabIndex = 0;

  initData(GuideModelDomain abilitiesData) {
    this.taskData = abilitiesData;
    if (listTask.length == 0) {
      getCategoryTasks();
    }
  }

  void expandItem(GuideModelDomain mapModel) {
    listTask.forEach((GuideModelDomain key, List<GuideModelDomain> value) {
      value.forEach((element) {
        if (identical(element, mapModel)) {
          element.isExpanded = true;
        }
      });
    });
    notifyListeners();
  }

  void colapseItem(GuideModelDomain mapModel) {
    listTask.forEach((GuideModelDomain key, List<GuideModelDomain> value) {
      value.forEach((element) {
        if (identical(element, mapModel)) {
          element.isExpanded = false;
        }
      });
    });
    notifyListeners();
  }

  List<String> getTabName() {
    return listTask.keys.toList().map((e) => e.name).toList();
  }

  List<GuideModelDomain> getTabData() {
    if (currentType == null) {
      return List<GuideModelDomain>();
    }
    return listTask[currentType];
  }

  changePage(int index) {
    tabIndex = index;
    currentType = category[index];
    if (listTask[currentType].length == 0) {
      getDetailCategoriesAbilities(currentType);
    } else {
      notifyListeners();
    }
  }

  void getCategoryTasks() async {
    GetGuideRequest getGuideRequest =
        GetGuideRequest.fromData(currentPageIndex, take, taskData.id);
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
        category.add(itemCategory);
        listTask[itemCategory] = List<GuideModelDomain>();
      });
      print("category abilities: ${listTask.length}");
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
        list.forEach((element) {
          listTask[guideModelDomain].add(GuideModelDomain.fromData(
              id: element.id,
              description: element.description,
              name: element.name,
              parentId: element.parentId,
              slug: element.slug,
              thumbnailUrl: element.thumbnailUrl));
        });
        notifyListeners();
      } else {
        allowLoadMore = false;
      }
    }
  }
}
