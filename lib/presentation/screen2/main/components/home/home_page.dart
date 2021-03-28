import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/keepalive_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page.dart';
import 'package:themoviedex/presentation/screen2/widgets/tabbar_home_widget.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    pages = [MoviesPage(), TvShowPage()];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Builder(builder: (context) {
        return Container(
          color: AppTheme.bottomNavigationBarBackground_light,
          child: Stack(children: [
            Column(
              children: [
                SizedBox(height: Adapt.px(20),),
                TabbarHomeWidget(pageController: pageController),
                Expanded(child: createPageView())
              ],
            ),
            createGradientWidget()
          ]),
        );
      }),
    );
  }

  Widget createPageView() {
    return PageView(
        physics: NeverScrollableScrollPhysics(),
        children: pages.map(_buildPage).toList(),
        controller: pageController,
        onPageChanged: (int index) => {});
  }

  Widget _buildPage(Widget page) {
    return KeepAliveWidget(page);
  }

  Widget createGradientWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 6,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xE6000000),
            Color(0x0),
          ],
        )),
      ),
    );
  }
}
