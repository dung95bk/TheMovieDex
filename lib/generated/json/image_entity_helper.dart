import 'package:themoviedex/data/model/remote/image_entity.dart';
import 'package:flutter/cupertino.dart';

imageEntityFromJson(ImageEntity data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> imageEntityToJson(ImageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	return data;
}