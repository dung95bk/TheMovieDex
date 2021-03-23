// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:themoviedex/data/model/remote/image_entity.dart';
import 'package:themoviedex/generated/json/image_entity_helper.dart';
import 'package:themoviedex/data/remote/response/get_category_detail_response_entity.dart';
import 'package:themoviedex/generated/json/get_category_detail_response_entity_helper.dart';
import 'package:themoviedex/data/model/remote/category_entity.dart';
import 'package:themoviedex/generated/json/category_entity_helper.dart';
import 'package:themoviedex/data/remote/request/get_detail_category_request.dart';
import 'package:themoviedex/generated/json/get_detail_category_request_helper.dart';
import 'package:themoviedex/data/remote/response/get_guide_response_entity.dart';
import 'package:themoviedex/generated/json/get_guide_response_entity_helper.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/generated/json/get_guide_request_helper.dart';
import 'package:themoviedex/data/remote/request/get_category_request.dart';
import 'package:themoviedex/generated/json/get_category_request_helper.dart';
import 'package:themoviedex/data/remote/request/get_detail_task_request.dart';
import 'package:themoviedex/generated/json/get_detail_task_request_helper.dart';
import 'package:themoviedex/data/remote/response/get_category_response_entity.dart';
import 'package:themoviedex/generated/json/get_category_response_entity_helper.dart';
import 'package:themoviedex/data/remote/response/get_detail_task_response_entity.dart';
import 'package:themoviedex/generated/json/get_detail_task_response_entity_helper.dart';
import 'package:themoviedex/data/remote/response/get_hot_response_entity.dart';
import 'package:themoviedex/generated/json/get_hot_response_entity_helper.dart';
import 'package:themoviedex/data/remote/request/get_token_request.dart';
import 'package:themoviedex/generated/json/get_token_request_helper.dart';
import 'package:themoviedex/data/remote/response/get_token_response_entity.dart';
import 'package:themoviedex/generated/json/get_token_response_entity_helper.dart';
import 'package:themoviedex/data/remote/request/get_list_image_request.dart';
import 'package:themoviedex/generated/json/get_list_image_request_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case ImageEntity:
			return imageEntityFromJson(data as ImageEntity, json) as T;			case GetCategoryDetailResponse:
			return getCategoryDetailResponseFromJson(data as GetCategoryDetailResponse, json) as T;			case GetCategoryDetailResponseData:
			return getCategoryDetailResponseDataFromJson(data as GetCategoryDetailResponseData, json) as T;			case GetCategoryDetailResponseSubData:
			return getCategoryDetailResponseSubDataFromJson(data as GetCategoryDetailResponseSubData, json) as T;			case CategoryEntity:
			return categoryEntityFromJson(data as CategoryEntity, json) as T;			case GetCategoryDetailRequest:
			return getCategoryDetailRequestFromJson(data as GetCategoryDetailRequest, json) as T;			case GetGuideResponse:
			return getGuideResponseFromJson(data as GetGuideResponse, json) as T;			case GetGuideResponseData:
			return getGuideResponseDataFromJson(data as GetGuideResponseData, json) as T;			case GetGuideRequest:
			return getGuideRequestFromJson(data as GetGuideRequest, json) as T;			case GetcategoryRequest:
			return getcategoryRequestFromJson(data as GetcategoryRequest, json) as T;			case GetDetailTaskRequest:
			return getDetailTaskRequestFromJson(data as GetDetailTaskRequest, json) as T;			case GetCategoryResponse:
			return getCategoryResponseFromJson(data as GetCategoryResponse, json) as T;			case GetCategoryResponseData:
			return getCategoryResponseDataFromJson(data as GetCategoryResponseData, json) as T;			case GetDetailTaskResponse:
			return getDetailTaskResponseFromJson(data as GetDetailTaskResponse, json) as T;			case GetDetailTaskResponseData:
			return getDetailTaskResponseDataFromJson(data as GetDetailTaskResponseData, json) as T;			case GetHotResponse:
			return getHotResponseFromJson(data as GetHotResponse, json) as T;			case GetHotResponseData:
			return getHotResponseDataFromJson(data as GetHotResponseData, json) as T;			case GetTokenRequest:
			return getTokenRequestFromJson(data as GetTokenRequest, json) as T;			case GetTokenResponse:
			return getTokenResponseFromJson(data as GetTokenResponse, json) as T;			case GetTokenResponseData:
			return getTokenResponseDataFromJson(data as GetTokenResponseData, json) as T;			case GetListImageRequest:
			return getListImageRequestFromJson(data as GetListImageRequest, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case ImageEntity:
			return imageEntityToJson(data as ImageEntity);			case GetCategoryDetailResponse:
			return getCategoryDetailResponseToJson(data as GetCategoryDetailResponse);			case GetCategoryDetailResponseData:
			return getCategoryDetailResponseDataToJson(data as GetCategoryDetailResponseData);			case GetCategoryDetailResponseSubData:
			return getCategoryDetailResponseSubDataToJson(data as GetCategoryDetailResponseSubData);			case CategoryEntity:
			return categoryEntityToJson(data as CategoryEntity);			case GetCategoryDetailRequest:
			return getCategoryDetailRequestToJson(data as GetCategoryDetailRequest);			case GetGuideResponse:
			return getGuideResponseToJson(data as GetGuideResponse);			case GetGuideResponseData:
			return getGuideResponseDataToJson(data as GetGuideResponseData);			case GetGuideRequest:
			return getGuideRequestToJson(data as GetGuideRequest);			case GetcategoryRequest:
			return getcategoryRequestToJson(data as GetcategoryRequest);			case GetDetailTaskRequest:
			return getDetailTaskRequestToJson(data as GetDetailTaskRequest);			case GetCategoryResponse:
			return getCategoryResponseToJson(data as GetCategoryResponse);			case GetCategoryResponseData:
			return getCategoryResponseDataToJson(data as GetCategoryResponseData);			case GetDetailTaskResponse:
			return getDetailTaskResponseToJson(data as GetDetailTaskResponse);			case GetDetailTaskResponseData:
			return getDetailTaskResponseDataToJson(data as GetDetailTaskResponseData);			case GetHotResponse:
			return getHotResponseToJson(data as GetHotResponse);			case GetHotResponseData:
			return getHotResponseDataToJson(data as GetHotResponseData);			case GetTokenRequest:
			return getTokenRequestToJson(data as GetTokenRequest);			case GetTokenResponse:
			return getTokenResponseToJson(data as GetTokenResponse);			case GetTokenResponseData:
			return getTokenResponseDataToJson(data as GetTokenResponseData);			case GetListImageRequest:
			return getListImageRequestToJson(data as GetListImageRequest);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'ImageEntity':
			return ImageEntity().fromJson(json);			case 'GetCategoryDetailResponse':
			return GetCategoryDetailResponse().fromJson(json);			case 'GetCategoryDetailResponseData':
			return GetCategoryDetailResponseData().fromJson(json);			case 'GetCategoryDetailResponseSubData':
			return GetCategoryDetailResponseSubData().fromJson(json);			case 'CategoryEntity':
			return CategoryEntity().fromJson(json);			case 'GetCategoryDetailRequest':
			return GetCategoryDetailRequest().fromJson(json);			case 'GetGuideResponse':
			return GetGuideResponse().fromJson(json);			case 'GetGuideResponseData':
			return GetGuideResponseData().fromJson(json);			case 'GetGuideRequest':
			return GetGuideRequest().fromJson(json);			case 'GetcategoryRequest':
			return GetcategoryRequest().fromJson(json);			case 'GetDetailTaskRequest':
			return GetDetailTaskRequest().fromJson(json);			case 'GetCategoryResponse':
			return GetCategoryResponse().fromJson(json);			case 'GetCategoryResponseData':
			return GetCategoryResponseData().fromJson(json);			case 'GetDetailTaskResponse':
			return GetDetailTaskResponse().fromJson(json);			case 'GetDetailTaskResponseData':
			return GetDetailTaskResponseData().fromJson(json);			case 'GetHotResponse':
			return GetHotResponse().fromJson(json);			case 'GetHotResponseData':
			return GetHotResponseData().fromJson(json);			case 'GetTokenRequest':
			return GetTokenRequest().fromJson(json);			case 'GetTokenResponse':
			return GetTokenResponse().fromJson(json);			case 'GetTokenResponseData':
			return GetTokenResponseData().fromJson(json);			case 'GetListImageRequest':
			return GetListImageRequest().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'ImageEntity':
			return List<ImageEntity>();			case 'GetCategoryDetailResponse':
			return List<GetCategoryDetailResponse>();			case 'GetCategoryDetailResponseData':
			return List<GetCategoryDetailResponseData>();			case 'GetCategoryDetailResponseSubData':
			return List<GetCategoryDetailResponseSubData>();			case 'CategoryEntity':
			return List<CategoryEntity>();			case 'GetCategoryDetailRequest':
			return List<GetCategoryDetailRequest>();			case 'GetGuideResponse':
			return List<GetGuideResponse>();			case 'GetGuideResponseData':
			return List<GetGuideResponseData>();			case 'GetGuideRequest':
			return List<GetGuideRequest>();			case 'GetcategoryRequest':
			return List<GetcategoryRequest>();			case 'GetDetailTaskRequest':
			return List<GetDetailTaskRequest>();			case 'GetCategoryResponse':
			return List<GetCategoryResponse>();			case 'GetCategoryResponseData':
			return List<GetCategoryResponseData>();			case 'GetDetailTaskResponse':
			return List<GetDetailTaskResponse>();			case 'GetDetailTaskResponseData':
			return List<GetDetailTaskResponseData>();			case 'GetHotResponse':
			return List<GetHotResponse>();			case 'GetHotResponseData':
			return List<GetHotResponseData>();			case 'GetTokenRequest':
			return List<GetTokenRequest>();			case 'GetTokenResponse':
			return List<GetTokenResponse>();			case 'GetTokenResponseData':
			return List<GetTokenResponseData>();			case 'GetListImageRequest':
			return List<GetListImageRequest>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}