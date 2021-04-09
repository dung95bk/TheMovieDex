import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/presentation/custom_widgets/keepalive_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/celeb/celeb_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/home_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/more/more_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/mymovie/my_movie_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page.dart';
import 'package:themoviedex/presentation/screen2/main/main_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/widgets/bottom_navigationbar/custom_bottom_navigation_bar.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [HomePage(), SearchPage(), MyMoviePage(),  CelebPage()];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainPageProvider provider =
        Provider.of<MainPageProvider>(context, listen: false);
    return OrientationBuilder(
      builder: (context, orientation) {
        Adapt.initContext(context);
        return  Builder(
          builder: (context) {
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
                extendBody: false,
                backgroundColor: AppTheme.bottomNavigationBarBackground_light,
                body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    children: pages.map(_buildPage).toList(),
                    controller: pageController,
                    onPageChanged: (int i) => {}),
                bottomNavigationBar: CustomBottomNavigationBar(
                  bottomNavigationKey: provider.bottomNavigationKey,
                  pageChange: (index) {
                    pageController.jumpToPage(index);
                  },
                ));
          },
        );
      },
    );
  }
}
