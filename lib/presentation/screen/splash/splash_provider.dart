import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get_version/get_version.dart';
import 'package:themoviedex/data/local/sharepreference/share_preference_key.dart';
import 'package:themoviedex/data/local/sharepreference/sharepreference_manager.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_token_request.dart';
import 'package:themoviedex/data/remote/response/get_token_response_entity.dart';
import 'package:package_info/package_info.dart';

class SplashProvider extends ChangeNotifier {
  String token = "";
  void getToken() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectVersion = "1.1";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String udid = await FlutterUdid.udid;
    GetTokenRequest getTokenRequest =
        GetTokenRequest.fromData(udid, "1.1");
    Response response = await Http.instance.getToken(getTokenRequest);
    if (response.statusCode == 200) {
      GetTokenResponse getTokenResponse = GetTokenResponse().fromJson(response.data);
      token = getTokenResponse.data.token;
      decodeToken(token);
      notifyListeners();
    }
  }

  void decodeToken(String token) async {
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8("55fc3437117a1de2");
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(
        "11b335b620552229010f4937855d2ebo");
    final encrypter = EncryptPack.Encrypter(EncryptPack.AES(
        keyObj, mode: EncryptPack.AESMode.cbc,
        padding: "PKCS7"));
    final decrypted = encrypter.decrypt64(
        token, iv: ivObj);
    print("${decrypted}");
    await SharePreferenceManager.setString(PrefKey.TOKEN, decrypted);
  }
}
