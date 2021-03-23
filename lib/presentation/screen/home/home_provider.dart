import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/model/local/image_model.dart';
import 'package:package_info/package_info.dart';

class HomeProvider extends ChangeNotifier {
  Future<String> getAppName() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return  packageInfo.appName;
  }

  void showBanner() {

  }


}