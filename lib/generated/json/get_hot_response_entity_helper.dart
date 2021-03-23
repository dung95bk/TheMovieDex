import 'package:themoviedex/data/remote/response/get_hot_response_entity.dart';

getHotResponseFromJson(GetHotResponse data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<GetHotResponseData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new GetHotResponseData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> getHotResponseToJson(GetHotResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['status'] = entity.status;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

getHotResponseDataFromJson(GetHotResponseData data, Map<String, dynamic> json) {
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

Map<String, dynamic> getHotResponseDataToJson(GetHotResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['source_url'] = entity.sourceUrl;
	data['medium_url'] = entity.mediumUrl;
	data['large_url'] = entity.largeUrl;
	data['thumbnail_url'] = entity.thumbnailUrl;
	return data;
}