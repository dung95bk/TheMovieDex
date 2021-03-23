import 'package:themoviedex/data/model/remote/category_entity.dart';

categoryEntityFromJson(CategoryEntity data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> categoryEntityToJson(CategoryEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	return data;
}