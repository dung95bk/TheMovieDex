import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetCategoryDetailResponse with JsonConvert<GetCategoryDetailResponse> {
  int code;
  String status;
  GetCategoryDetailResponseData data;
}

class GetCategoryDetailResponseData with JsonConvert<GetCategoryDetailResponseData> {
  @JSONField(name: "category_id")
  String categoryId;
  @JSONField(name: "category_name")
  String categoryName;
  List<GetCategoryDetailResponseSubData> images;
}

class GetCategoryDetailResponseSubData with JsonConvert<GetCategoryDetailResponseSubData> {
  String id;
  String name;
  @JSONField(name: "source_url")
  String sourceUrl;
  @JSONField(name: "medium_url")
  String mediumUrl;
  @JSONField(name: "large_url")
  String largeUrl;
  @JSONField(name: "thumbnail_url")
  String thumbnailUrl;
}
