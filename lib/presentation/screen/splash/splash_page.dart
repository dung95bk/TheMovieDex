import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/home/home_page.dart';
import 'package:themoviedex/presentation/screen/splash/splash_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SplashProvider>(context, listen: false).getToken();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _goFirstPage(BuildContext context) {
    NavigatorUtil.pushPageReplacement(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, SplashProvider provider, child) {
        return Container(
          child: Builder(builder: (context) {
            if(!provider.token.isEmpty) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                _goFirstPage(context);
              });
            }
            return  Image(
              image: AssetImage(R.img_logo_among_us),
              fit: BoxFit.cover,
            );
          }),
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
