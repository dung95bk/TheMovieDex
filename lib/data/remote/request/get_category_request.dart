import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetcategoryRequest with JsonConvert<GetcategoryRequest> {
  @JSONField(name: "page_index")
  int pageIndex;
  @JSONField(name: "page_size")
  int pageSize;

  GetcategoryRequest();

  GetcategoryRequest.fromData(this.pageIndex, this.pageSize);
}
