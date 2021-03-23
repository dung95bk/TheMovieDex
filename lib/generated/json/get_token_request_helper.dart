import 'package:themoviedex/data/remote/request/get_token_request.dart';

getTokenRequestFromJson(GetTokenRequest data, Map<String, dynamic> json) {
	if (json['user_id'] != null) {
		data.userId = json['user_id']?.toString();
	}
	if (json['app_version'] != null) {
		data.appVersion = json['app_version']?.toString();
	}
	return data;
}

Map<String, dynamic> getTokenRequestToJson(GetTokenRequest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['user_id'] = entity.userId;
	data['app_version'] = entity.appVersion;
	return data;
}