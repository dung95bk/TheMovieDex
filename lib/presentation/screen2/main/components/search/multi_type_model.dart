import 'dart:convert';

import 'package:themoviedex/data/remote/models/video_list.dart';

class MultiTypeModel {
  int page;
  List<dynamic> results = List();
  int total_results;
  int total_pages;

  factory MultiTypeModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new MultiTypeModel.fromJson(json.decode(jsonStr))
          : new MultiTypeModel.fromJson(jsonStr);

  MultiTypeModel.fromJson(json) {
    if (json["page"] != null) {
      page = json["page"]?.toInt();
    }
    if (json["total_results"] != null) {
      total_results = json["total_results"]?.toInt();
    }
    if (json["total_pages"] != null) {
      total_pages = json["total_pages"]?.toInt();
    }

    if (json["results"] != null) {
      (json["results"] as List).forEach((element) {
        if (element["media_type"].toString() == "tv") {
          results.add(VideoListResult.fromJson(element));
        } else if (element["media_type"].toString() == "movie") {
          results.add(VideoListResult.fromJson(element));
        }
      });
    }
  }
}
