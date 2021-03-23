import 'package:themoviedex/data/remote/response/get_category_response_entity.dart';

getCategoryResponseFromJson(GetCategoryResponse data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<GetCategoryResponseData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new GetCategoryResponseData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> getCategoryResponseToJson(GetCategoryResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['status'] = entity.status;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

getCategoryResponseDataFromJson(GetCategoryResponseData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['slug'] != null) {
		data.slug = json['slug']?.toString();
	}
	if (json['thumbnail_url'] != null) {
		data.thumbnailUrl = json['thumbnail_url']?.toString();
	}
	return data;
}

Map<String, dynamic> getCategoryResponseDataToJson(GetCategoryResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['slug'] = entity.slug;
	data['thumbnail_url'] = entity.thumbnailUrl;
	return data;
}