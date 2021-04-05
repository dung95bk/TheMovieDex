import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/widgets/bottom_navigationbar/custom_bottom_navigation_bar_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  Key bottomNavigationKey;
  ValueChanged<int> pageChange;

  CustomBottomNavigationBar({Key key, @required this.bottomNavigationKey, @required this.pageChange})
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
          return
            BottomNavigationBar(
              key: widget.bottomNavigationKey,
              backgroundColor: Color(0xE6000000),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      provider.currentIndex == 0
                          ? AssetImage(R.img_ic_tab_home_active)
                          : AssetImage(R.img_ic_tab_home_inactive),
                    ),
                    label: "Home"

                ),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      provider.currentIndex == 1
                          ? AssetImage(R.img_ic_tab_search_active)
                          : AssetImage(R.img_ic_tab_search_inactive),
                    ),
                    label: "Search"

                ),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      provider.currentIndex == 2
                          ? AssetImage(R.img_ic_tab_movie_active)
                          : AssetImage(R.img_ic_tab_movie_inactive),
                    ),
                    label: "Movie"

                ),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      provider.currentIndex == 3
                          ? AssetImage(R.img_ic_tab_celeb_active)
                          : AssetImage(R.img_ic_tab_celeb_inactive),
                    ),
                    label: "Celeb"

                ),
                // BottomNavigationBarItem(
                //     icon: ImageIcon(
                //       provider.currentIndex == 4
                //           ? AssetImage(R.img_ic_tab_more_active)
                //           : AssetImage(R.img_ic_tab_more_inactive),
                //     ),
                //     label: "More"
                // ),
              ],
              currentIndex: provider.currentIndex,
              selectedItemColor: AppTheme.item_bottomNavigation_selected,
              unselectedItemColor: AppTheme
                  .item_bottomNavigation_unselected,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (int index) {
                provider.currentIndex = index;
                widget.pageChange(index);
              },
              type: BottomNavigationBarType.fixed,
            );

        }));
  }
}
