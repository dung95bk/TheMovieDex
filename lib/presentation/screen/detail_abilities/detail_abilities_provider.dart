import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';

class DetailAbilitiesProvider extends ChangeNotifier {


  void initData(GuideModelDomain abilitiesModel) async {
    GetGuideRequest getGuideRequest =
    GetGuideRequest.fromData(0, 20, abilitiesModel.id);
    Response response;
    try {
      response = await Http.instance.getGuide(getGuideRequest);
      print("${response.data}");
    } catch (e) {}
    if (response != null && response.statusCode == 200) {}
  }
}