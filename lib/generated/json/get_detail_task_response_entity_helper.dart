import 'package:themoviedex/data/remote/response/get_detail_task_response_entity.dart';

getDetailTaskResponseFromJson(GetDetailTaskResponse data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<GetDetailTaskResponseData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new GetDetailTaskResponseData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> getDetailTaskResponseToJson(GetDetailTaskResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['status'] = entity.status;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

getDetailTaskResponseDataFromJson(GetDetailTaskResponseData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['parent_id'] != null) {
		data.parentId = json['parent_id']?.toString();
	}
	if (json['slug'] != null) {
		data.slug = json['slug']?.toString();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	if (json['thumbnail_url'] != null) {
		data.thumbnailUrl = json['thumbnail_url']?.toString();
	}
	return data;
}

Map<String, dynamic> getDetailTaskResponseDataToJson(GetDetailTaskResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['parent_id'] = entity.parentId;
	data['slug'] = entity.slug;
	data['description'] = entity.description;
	data['thumbnail_url'] = entity.thumbnailUrl;
	return data;
}