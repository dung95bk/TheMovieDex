import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetGuideRequest with JsonConvert<GetGuideRequest> {

  @JSONField(name: "page_index")
  int pageIndex;
  @JSONField(name: "page_size")
  int pageSize;
  @JSONField(name: "parent_id")
  String parentId;

  GetGuideRequest();

  GetGuideRequest.fromData(this.pageIndex, this.pageSize, this.parentId);
}
