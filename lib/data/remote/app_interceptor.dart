import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:themoviedex/data/local/sharepreference/share_preference_key.dart';
import 'package:themoviedex/data/local/sharepreference/sharepreference_manager.dart';
class AppInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async{
    print("Api: ${options.path}: ${options.data}");
    if(!options.path.contains("get-token")) {
      String token = await SharePreferenceManager.getString(PrefKey.TOKEN);
      options.headers["Authorization"] = token;
      print("token: ${token}");
    }
    print("header : ${options.headers}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    var request = jsonDecode(response.request.data);
    print("${request['api']} - RESPONSE: ${response.data}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
