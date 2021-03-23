import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:themoviedex/data/helper/api_name.dart';
import 'package:themoviedex/data/helper/remote_config.dart';
import 'package:themoviedex/data/local/sharepreference/sharepreference_manager.dart';
import 'package:themoviedex/data/remote/app_interceptor.dart';
import 'package:themoviedex/data/remote/request/get_category_request.dart';
import 'package:themoviedex/data/remote/request/get_detail_category_request.dart';
import 'package:themoviedex/data/remote/request/get_detail_task_request.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/request/get_list_image_request.dart';
import 'package:themoviedex/data/remote/request/get_token_request.dart';

class Http {
  static final Http _instance = Http._internal();

  static Http get instance => _instance;

  final _dio = Dio();

  factory Http() {
    return _instance;
  }

  Http._internal() {
    _dio.options.baseUrl = RemoteConfig.baseUrl;
    _dio.options.connectTimeout = RemoteConfig.httpConnectTimeout;
    _dio.options.receiveTimeout = RemoteConfig.httpReceiveTimeout;
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.interceptors.add(AppInterceptor());
  }

  Future<Response> getToken(GetTokenRequest getTokenRequest) async {
    return _dio.post("/${ApiName.GET_TOKEN}",
        data: jsonEncode(getTokenRequest.toJson()));
  }

  Future<Response> getListImage(GetListImageRequest getListImageRequest) async {
    return _dio.post("/${ApiName.GET_LIST_IMAGE_HOT}",
        data: jsonEncode(getListImageRequest.toJson()));
  }

  Future<Response> getListCategory(
      GetcategoryRequest getcategoryRequest) async {
    return _dio.post("/${ApiName.GET_CATEGORIES}",
        data: jsonEncode(getcategoryRequest.toJson()));
  }

  Future<Response> getCategoryDetail(
      GetCategoryDetailRequest getCategoryDetailRequest) async {
    return _dio.post("/${ApiName.GET_CATEGORIES_DETAIL}",
        data: jsonEncode(getCategoryDetailRequest.toJson()));
  }

  Future<Response> getGuide(
      GetGuideRequest getGuideRequest) async {
    return _dio.post("/${ApiName.GET_GUIDE}",
        data: jsonEncode(getGuideRequest.toJson()));
  }

  Future<Response> getDetailTask(
      GetDetailTaskRequest getDetailTaskRequest) async {
    return _dio.post("/${ApiName.GET_DETAIL_TASK}",
        data: jsonEncode(getDetailTaskRequest.toJson()));
  }

  Future<Response> executeRequest(String request) async {
    return _dio.post("/", data: request);
  }
}
