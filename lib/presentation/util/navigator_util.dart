import 'dart:io';

import 'package:flutter/material.dart';

class NavigatorUtil {
  static Future pushPageNamed(
      BuildContext context, String link, Object arguments) {
    return Navigator.pushNamed(context, link, arguments: arguments);
  }

  static Future pushPageReplacementNamed(
      BuildContext context, String link, Object arguments) {
    return Navigator.pushReplacementNamed(context, link, arguments: arguments);
  }


  static Future pushPage(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );

    return val;
  }

  static Future pushPageDialog(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );

    return val;
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static popMultiPage(BuildContext context, int numPagePop) {
    int countPage = 0;
    Navigator.of(context).popUntil((route) => countPage++ > numPagePop);
  }

  static popSinglePage(BuildContext context) {
    Navigator.of(context).pop();
  }

  static exitApp(BuildContext context) {
    exit(0);
  }
}
