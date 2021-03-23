import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/exit_dialog.dart';
import 'package:themoviedex/presentation/custom_widgets/slide_tab.dart';
import 'package:themoviedex/presentation/screen/guide_page/guide_page.dart';
import 'package:themoviedex/presentation/screen/home/home_provider.dart';
import 'package:themoviedex/presentation/screen/wallpaper_page/wallpaper_page.dart';
import 'package:themoviedex/presentation/util/ads_util.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:themoviedex/presentation/util/screen_util.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  int selectedIndex = 0;
  List<String> names = List<String>();
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    names.add("Wallpaper");
    names.add("Guide");
    super.initState();
  }

  @override
  void dispose() {
    // _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<HomeProvider>(context, listen: false).getAppName(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        return WillPopScope(
          onWillPop: () => OptionDialog().showOtionDialog(
              context, snapshot.data, 'Are you sure want to quit', () {
            NavigatorUtil.popSinglePage(context);
          }, () {
            NavigatorUtil.exitApp(context);
          }),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      buildPageView(context),
                      buildBottomBar(context),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPageView(BuildContext context) {
    return Expanded(
      flex: 1,
      child: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          WallpaperPage(),
          GuidePage(),
        ],
      ),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black)]),
      child: TabSlideChoose(_bottomNavigationKey, names,
          (int index) => {pageController.jumpToPage(index)}),
    );
  }

  void pageChanged(int index) {
    print("page button${index}");

    final TabSlideChooseState navBarState = _bottomNavigationKey.currentState;
    navBarState.setPage(index);
  }
}
