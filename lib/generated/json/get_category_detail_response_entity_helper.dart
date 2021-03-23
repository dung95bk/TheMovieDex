import 'package:themoviedex/data/remote/response/get_category_detail_response_entity.dart';

getCategoryDetailResponseFromJson(GetCategoryDetailResponse data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['data'] != null) {
		data.data = new GetCategoryDetailResponseData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> getCategoryDetailResponseToJson(GetCategoryDetailResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['status'] = entity.status;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

getCategoryDetailResponseDataFromJson(GetCategoryDetailResponseData data, Map<String, dynamic> json) {
	if (json['category_id'] != null) {
		data.categoryId = json['category_id']?.toString();
	}
	if (json['category_name'] != null) {
		data.categoryName = json['category_name']?.toString();
	}
	if (json['images'] != null) {
		data.images = new List<GetCategoryDetailResponseSubData>();
		(json['images'] as List).forEach((v) {
			data.images.add(new GetCategoryDetailResponseSubData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> getCategoryDetailResponseDataToJson(GetCategoryDetailResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['category_id'] = entity.categoryId;
	data['category_name'] = entity.categoryName;
	if (entity.images != null) {
		data['images'] =  entity.images.map((v) => v.toJson()).toList();
	}
	return data;
}

getCategoryDetailResponseSubDataFromJson(GetCategoryDetailResponseSubData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['source_url'] != null) {
		data.sourceUrl = json['source_url']?.toString();
	}
	if (json['medium_url'] != null) {
		data.mediumUrl = json['medium_url']?.toString();
	}
	if (json['large_url'] != null) {
		data.largeUrl = json['large_url']?.toString();
	}
	if (json['thumbnail_url'] != null) {
		data.thumbnailUrl = json['thumbnail_url']?.toString();
	}
	return data;
}

Map<String, dynamic> getCategoryDetailResponseSubDataToJson(GetCategoryDetailResponseSubData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['source_url'] = entity.sourceUrl;
	data['medium_url'] = entity.mediumUrl;
	data['large_url'] = entity.largeUrl;
	data['thumbnail_url'] = entity.thumbnailUrl;
	return data;
}