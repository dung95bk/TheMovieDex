import 'package:themoviedex/data/remote/request/get_detail_task_request.dart';

getDetailTaskRequestFromJson(GetDetailTaskRequest data, Map<String, dynamic> json) {
	if (json['category_id'] != null) {
		data.categoryId = json['category_id']?.toString();
	}
	return data;
}

Map<String, dynamic> getDetailTaskRequestToJson(GetDetailTaskRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['category_id'] = entity.categoryId;
	return data;
}