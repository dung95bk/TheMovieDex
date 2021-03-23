import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetHotResponse with JsonConvert<GetHotResponse> {
  int code;
  String status;
  List<GetHotResponseData> data;
}

class GetHotResponseData with JsonConvert<GetHotResponseData> {
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
