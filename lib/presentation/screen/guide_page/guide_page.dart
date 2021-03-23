import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/abilities/abilities_page.dart';
import 'package:themoviedex/presentation/screen/colors/colors_page.dart';
import 'package:themoviedex/presentation/screen/groups/groups_page.dart';
import 'package:themoviedex/presentation/screen/guide_page/guide_provider.dart';
import 'package:themoviedex/presentation/screen/location/location_page.dart';
import 'package:themoviedex/presentation/screen/map/map_page.dart';
import 'package:themoviedex/presentation/screen/tasks/task_page.dart';
import 'package:provider/provider.dart';

class GuidePage extends StatefulWidget {
  GuidePage({Key key}) : super(key: key);

  @override
  _GuidePageState createState() {
    return _GuidePageState();
  }
}

class _GuidePageState extends State<GuidePage> with TickerProviderStateMixin {
  List<String> category = List<String>();
  List<Tab> rows = [];
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    category.add("Maps");
    category.add("Groups");
    category.add("Colors");
    category.add("Locations");
    category.add("Abilities");
    category.add("Tasks");

    super.initState();
    Provider.of<GuideProvider>(context, listen: false).initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black)],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            initialIndex: 0,
            length: 6,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (int index) {
                pageController.jumpToPage(index);
              },
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withAlpha(100)),
              isScrollable: true,
              tabs: _tabs(category),
            ),
          ),
        ),
        Builder(
          builder: (context) =>
              Consumer(builder: (context, GuideProvider provider, child) {
            return buildPageView(context, provider.guideList);
          }),
        )
      ]),
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
                        color: Colors.white),
                  ),
                ),
              ]),
        )),
      );
    }
    return rows;
  }

  Widget buildPageView(BuildContext context, List<GuideModelDomain> guideList) {
    List<Widget> listPage = [];
    if(guideList.isNotEmpty) {
      print("guide Le: ${guideList.length}");
      listPage = <Widget>[
        MapPage(mapData: guideList[0]),
        GroupsPage(groupData: guideList[1],),
        ColorsPage(colorData: guideList[2],),
        LocationPage(locationData: guideList[3],),
        AbilitiesPage(abilitiesData: guideList[4],),
        TasksPage(taskData: guideList[5],),
      ];
    }
    return Expanded(
      flex: 1,
      child: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: pageController,
        children: listPage
      ),
    );
  }

  Widget createAppBar() {
    return Container(
      height: 50,
      color: Colors.deepPurpleAccent.withOpacity(0.5),
    );
  }
}
