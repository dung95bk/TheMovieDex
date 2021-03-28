import 'package:flutter/cupertino.dart';

class LocalConfig {
  LocalConfig._();
  static final LocalConfig instance = LocalConfig._();

  dynamic _config;

  String get timezone => _config['timezone'];


  Future init(BuildContext context) async {

  }


}
