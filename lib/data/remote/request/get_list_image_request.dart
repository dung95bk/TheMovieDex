import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetListImageRequest with JsonConvert<GetListImageRequest> {
	@JSONField(name: "page_index")
	int pageIndex;
	@JSONField(name: "page_size")
	int pageSize;

	GetListImageRequest();

  GetListImageRequest.fromData(this.pageIndex, this.pageSize);
}
