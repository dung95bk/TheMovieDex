import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetDetailTaskResponse with JsonConvert<GetDetailTaskResponse> {
  int code;
  String status;
  List<GetDetailTaskResponseData> data;
}

class GetDetailTaskResponseData with JsonConvert<GetDetailTaskResponseData> {
  String id;
  String name;
  @JSONField(name: "parent_id")
  String parentId;
  String slug;
  String description;
  @JSONField(name: "thumbnail_url")
  String thumbnailUrl;
}
