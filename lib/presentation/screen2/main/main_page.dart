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
          key: state.scaffoldKey,
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: state.pages.map(_buildPage).toList(),
            controller: pageController,
            onPageChanged: (int i) =>

          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: _theme.backgroundColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    state.selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    size: Adapt.px(44)),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    state.selectedIndex == 1
                        ? Icons.movie_creation
                        : Icons.movie_creation_outlined,
                    size: Adapt.px(44)),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    state.selectedIndex == 2
                        ? Icons.calendar_today
                        : Icons.calendar_today_outlined,
                    size: Adapt.px(44)),
                label: "My Movie",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  state.selectedIndex == 3
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  size: Adapt.px(44),
                ),
                label: "Celeb",
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: _theme.tabBarTheme.labelColor,
            unselectedItemColor: _theme.tabBarTheme.unselectedLabelColor,
            onTap: (int index) {
              pageController.jumpToPage(index);
            },
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

}
