import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/presentation/screen2/main/widgets/bottom_navigationbar/custom_bottom_navigation_bar_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  Key bottomNavigationKey;

  CustomBottomNavigationBar({Key key, @required this.bottomNavigationKey})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() {
    return _CustomBottomNavigationBarState();
  }
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  CustomBottomNavigationBarProvider providerr;
  @override
  void initState() {
    super.initState();
    providerr = CustomBottomNavigationBarProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomBottomNavigationBarProvider>.value(
        value: providerr,
        child: Consumer(builder:
            (context, CustomBottomNavigationBarProvider provider, child) {
          return BottomNavigationBar(
            key: widget.bottomNavigationKey,
            backgroundColor: AppTheme.bottomNavigationBarBackground_light,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    provider.currentIndex == 0
                        ? Icons.home
                        : Icons.home_outlined,
                    size: Adapt.px(44)),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    provider.currentIndex == 1
                        ? Icons.movie_creation
                        : Icons.movie_creation_outlined,
                    size: Adapt.px(44)),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    provider.currentIndex == 2
                        ? Icons.calendar_today
                        : Icons.calendar_today_outlined,
                    size: Adapt.px(44)),
                label: "My Movie",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  provider.currentIndex == 3
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  size: Adapt.px(44),
                ),
                label: "Celeb",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  provider.currentIndex == 4
                      ? Icons.people
                      : Icons.people_alt_outlined,
                  size: Adapt.px(44),
                ),
                label: "Celeb",
              ),
            ],
            currentIndex: provider.currentIndex,
            selectedItemColor: AppTheme.item_bottomNavigation_selected,
            unselectedItemColor: AppTheme.item_bottomNavigation_unselected,
            onTap: (int index) {
              provider.currentIndex = index;
              print("Hello");
            },
            type: BottomNavigationBarType.fixed,
          );
        }));
  }
}
