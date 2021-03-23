import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceManager {
  SharePreferenceManager._();

  // -------------------------------------START------------------------------------
  static Future<dynamic> instance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<dynamic> get(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key) ?? defaultValue;
  }

  static Future<String> getString(String key,
      {String defaultValue = ""}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  static Future<double> getDouble(String key,
      {double defaultValue = 0.0}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key) ?? defaultValue;
  }

  static Future<bool> getBool(String key, {bool defaultValue = true}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? defaultValue;
  }

  static Future<List<String>> getStringList(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key) ?? List<String>();
  }

  static Future<Set<String>> getKeys(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getKeys();
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(key, value);
  }

  static Future<bool> setString(String key, String defaultValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, defaultValue);
  }

  static Future<bool> setDouble(String key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setDouble(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setStringList(key, value);
  }
// -------------------------------------_END------------------------------------

}
