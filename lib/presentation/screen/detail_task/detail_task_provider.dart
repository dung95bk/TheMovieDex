import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_detail_task_request.dart';
import 'package:themoviedex/data/remote/response/get_detail_task_response_entity.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class DetailTaskProvider extends ChangeNotifier {
  String categoryId = "";
  GuideModelDomain guideModelDomain;

  DetailTaskProvider(String id) {
    this.categoryId = id;
    getDetailTask();
  }

  void getDetailTask() async {
    GetDetailTaskRequest getDetailTaskRequest =
        GetDetailTaskRequest.fromData(categoryId);
    Response response;
    try {
      response = await Http.instance.getDetailTask(getDetailTaskRequest);
      print("${response.data}");
    } catch (e) {}
    if (response != null && response.statusCode == 200) {
      GetDetailTaskResponse getDetailTaskResponse =
          GetDetailTaskResponse().fromJson(response.data);

      var listData = getDetailTaskResponse.data;

      if (listData.length > 0) {
        var data = listData[0];
        guideModelDomain = GuideModelDomain.fromData(
            id: data.id,
            description: data.description,
            name: data.name,
            parentId: data.parentId,
            slug: data.slug,
            thumbnailUrl: data.thumbnailUrl);
        notifyListeners();
        print("lkmkm");

      }
    }
  }
}
