import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/keepalive_widget.dart';
import 'package:themoviedex/presentation/util/adapt.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          Adapt.initContext(context);
          final pageController = PageController();
          final _lightTheme = ThemeData.light().copyWith(
              backgroundColor: Colors.white,
              tabBarTheme: TabBarTheme(
                  labelColor: Color(0XFF505050),
                  unselectedLabelColor: Colors.grey));
          final _darkTheme = ThemeData.dark().copyWith(
              backgroundColor: Color(0xFF303030),
              tabBarTheme: TabBarTheme(
                  labelColor: Colors.white, unselectedLabelColor: Colors.grey));
          final MediaQueryData _mediaQuery = MediaQuery.of(context);
          final ThemeData _theme =
          _mediaQuery.platformBrightness == Brightness.light
              ? _lightTheme
              : _darkTheme;
          Widget _buildPage(Widget page) {
            return KeepAliveWidget(page);
          }

          return Scaffold(
              body: Container(

              )
          );
        });
  }
}
