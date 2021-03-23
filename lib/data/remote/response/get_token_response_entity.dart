import 'package:themoviedex/generated/json/base/json_convert_content.dart';

class GetTokenResponse with JsonConvert<GetTokenResponse> {
	int code;
	String status;
	GetTokenResponseData data;
}

class GetTokenResponseData with JsonConvert<GetTokenResponseData> {
	String token;
}
