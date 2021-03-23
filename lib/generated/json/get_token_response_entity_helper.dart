import 'package:themoviedex/data/remote/response/get_token_response_entity.dart';

getTokenResponseFromJson(GetTokenResponse data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['data'] != null) {
		data.data = new GetTokenResponseData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> getTokenResponseToJson(GetTokenResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['status'] = entity.status;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

getTokenResponseDataFromJson(GetTokenResponseData data, Map<String, dynamic> json) {
	if (json['token'] != null) {
		data.token = json['token']?.toString();
	}
	return data;
}

Map<String, dynamic> getTokenResponseDataToJson(GetTokenResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['token'] = entity.token;
	return data;
}