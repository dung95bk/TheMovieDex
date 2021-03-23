import 'package:themoviedex/data/remote/request/get_guide_request.dart';

getGuideRequestFromJson(GetGuideRequest data, Map<String, dynamic> json) {
	if (json['page_index'] != null) {
		data.pageIndex = json['page_index']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	if (json['parent_id'] != null) {
		data.parentId = json['parent_id']?.toString();
	}
	return data;
}

Map<String, dynamic> getGuideRequestToJson(GetGuideRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page_index'] = entity.pageIndex;
	data['page_size'] = entity.pageSize;
	data['parent_id'] = entity.parentId;
	return data;
}