import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetCategoryDetailRequest with JsonConvert<GetCategoryDetailRequest> {
  @JSONField(name: "page_index")
  int pageIndex;
  @JSONField(name: "page_size")
  int pageSize;
  @JSONField(name: "category")
  String categoryId;

  GetCategoryDetailRequest();

  GetCategoryDetailRequest.fromData(this.pageIndex, this.pageSize, this.categoryId);
}
