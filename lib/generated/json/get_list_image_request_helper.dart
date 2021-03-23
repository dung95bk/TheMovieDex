import 'package:themoviedex/data/remote/request/get_list_image_request.dart';

getListImageRequestFromJson(GetListImageRequest data, Map<String, dynamic> json) {
	if (json['page_index'] != null) {
		data.pageIndex = json['page_index']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	return data;
}

Map<String, dynamic> getListImageRequestToJson(GetListImageRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page_index'] = entity.pageIndex;
	data['page_size'] = entity.pageSize;
	return data;
}