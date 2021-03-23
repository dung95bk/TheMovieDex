import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetCategoryResponse with JsonConvert<GetCategoryResponse> {
  int code;
  String status;
  List<GetCategoryResponseData> data;
}

class GetCategoryResponseData with JsonConvert<GetCategoryResponseData> {
  String id;
  String name;
  String slug;
  @JSONField(name: "thumbnail_url")
  String thumbnailUrl;
}
