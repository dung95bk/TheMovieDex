import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

import 'get_guide_request.dart';

class GetDetailTaskRequest with JsonConvert<GetGuideRequest> {

  @JSONField(name: "category_id")
  String categoryId;

  GetDetailTaskRequest();

  GetDetailTaskRequest.fromData(this.categoryId);
}
