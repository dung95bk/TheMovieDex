import 'package:themoviedex/generated/json/base/json_convert_content.dart';
import 'package:themoviedex/generated/json/base/json_field.dart';

class GetTokenRequest with JsonConvert<GetTokenRequest> {
	@JSONField(name: "user_id")
	String userId;
	@JSONField(name: "app_version")
	String appVersion;

	GetTokenRequest();

  GetTokenRequest.fromData(this.userId, this.appVersion);
}
