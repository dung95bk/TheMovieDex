import 'dart:core';

import 'package:intl/intl.dart';

String convertTime(String data) {
  if (data == null) {
    print("Time convert is null");
    return "";
  }
  try {
    return DateFormat.yMMMd().format(DateTime.parse(data));
  } on Exception catch (e) {
    print(e.toString());
    return "";
  }
}
