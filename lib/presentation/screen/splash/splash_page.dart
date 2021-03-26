import 'dart:async';

import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/screen/home/home_page.dart';
import 'package:themoviedex/presentation/screen/splash/splash_provider.dart';
import 'package:themoviedex/presentation/screen2/item_custom/item_custom.dart';
import 'package:themoviedex/presentation/screen2/main/main_page.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  String data;

  SplashPage({Key key, @required this.data}) : super(key: key);

  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      _goFirstPage(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _goFirstPage(BuildContext context) {
    NavigatorUtil.pushPageReplacement(context, ItemCustomWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, SplashProvider provider, child) {
        return Container(
          color: AppTheme.nearlyBlack,
        );
      },
    );
  }
}

class SplashArgument {
  final String data;
  static const String routeName = "Splash";

  SplashArgument(this.data);
}
