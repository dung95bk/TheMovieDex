import 'package:themoviedex/data/remote/request/get_detail_category_request.dart';

getCategoryDetailRequestFromJson(GetCategoryDetailRequest data, Map<String, dynamic> json) {
	if (json['page_index'] != null) {
		data.pageIndex = json['page_index']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	if (json['category'] != null) {
		data.categoryId = json['category']?.toString();
	}
	return data;
}

Map<String, dynamic> getCategoryDetailRequestToJson(GetCategoryDetailRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page_index'] = entity.pageIndex;
	data['page_size'] = entity.pageSize;
	data['category'] = entity.categoryId;
	return data;
}