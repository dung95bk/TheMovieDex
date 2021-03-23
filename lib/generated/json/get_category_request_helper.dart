import 'package:themoviedex/data/remote/request/get_category_request.dart';

getcategoryRequestFromJson(GetcategoryRequest data, Map<String, dynamic> json) {
	if (json['page_index'] != null) {
		data.pageIndex = json['page_index']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	return data;
}

Map<String, dynamic> getcategoryRequestToJson(GetcategoryRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page_index'] = entity.pageIndex;
	data['page_size'] = entity.pageSize;
	return data;
}