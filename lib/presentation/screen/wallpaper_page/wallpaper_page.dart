import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/slide_tab_wallpaper.dart';
import 'package:themoviedex/presentation/screen/category/category_page.dart';
import 'package:themoviedex/presentation/screen/favorited/favorited_page.dart';
import 'package:themoviedex/presentation/screen/listwallpaper/list_wallpaper_page.dart';
import 'package:themoviedex/presentation/screen/wallpaper_page/wallpaper_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:themoviedex/presentation/custom_widgets/setting_dialog.dart';


class WallpaperPage extends StatefulWidget {
  WallpaperPage({Key key}) : super(key: key);

  @override
  _WallpaperPageState createState() {
    return _WallpaperPageState();
  }
}

class _WallpaperPageState extends State<WallpaperPage> {
  int selectedIndex = 0;
  List<String> names = List<String>();
  Widget pageCategory;
  Widget pageListHot;
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  List<Tab> rows = [];

  @override
  void initState() {
    print("initState Wallpaper");
    names.add("Categories");
    names.add("Hot");
    super.initState();
    pageCategory = CategoryPage();
    pageListHot = ListWallpaperPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onTap: ()=> SettingDialog().showSettingDialog(context)
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black)],
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (int index) =>
                            {pageController.jumpToPage(index)},
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withAlpha(200)),
                        isScrollable: true,
                        tabs: _tabs(names),
                      ),
                    ),
                  ),
                ),
              ]),
              GestureDetector(
                onTap: () => NavigatorUtil.pushPage(context, FavoritedPage()),
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        buildPageView(context)
      ],
    );
  }

  List<Tab> _tabs(List<String> names) {
    rows.clear();
    for (var tab = 0; tab < names.length; tab++) {
      rows.add(
        Tab(
            child: Container(
          padding: EdgeInsets.all(0.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    names[tab],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ]),
        )),
      );
    }
    return rows;
  }

  Widget buildPageView(BuildContext context) {
    print("buildPageview");
    return Expanded(
      flex: 1,
      child: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          pageCategory,
          pageListHot,
        ],
      ),
    );
  }
}
