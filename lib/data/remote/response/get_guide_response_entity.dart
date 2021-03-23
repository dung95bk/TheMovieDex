import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetGuideResponse with JsonConvert<GetGuideResponse> {
  int code;
  String status;
  List<GetGuideResponseData> data;
}

class GetGuideResponseData with JsonConvert<GetGuideResponseData> {
  String id;
  @JSONField(name: "parent_id")
  String parentId;
  String name;
  String slug;
  String description;
  @JSONField(name: "thumbnail_url")
  String thumbnailUrl;
}
