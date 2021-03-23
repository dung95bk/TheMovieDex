import 'package:flutter/material.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/custom_widgets/custom_tabbar.dart';
import 'package:themoviedex/presentation/custom_widgets/list_expandable_abilities.dart';
import 'package:themoviedex/presentation/screen/detail_abilities/detail_abilities_page.dart';
import 'package:themoviedex/presentation/screen/detail_task/detail_task_page.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:provider/provider.dart';

import 'abilities_page_provider.dart';

class AbilitiesPage extends StatefulWidget {
  GuideModelDomain abilitiesData;

  AbilitiesPage({Key key, this.abilitiesData}) : super(key: key);

  @override
  _AbilitiesPageState createState() {
    return _AbilitiesPageState();
  }
}

class _AbilitiesPageState extends State<AbilitiesPage> {
  List<Tab> rows = [];
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AbilitiesPageProvider>(context, listen: false)
          .initData(abilitiesData: widget.abilitiesData);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(R.img_img_splash),
      Consumer(builder: (context, AbilitiesPageProvider provider, child) {
        return provider.getTabName().length == 0
            ? SizedBox()
            : Column(
                children: [
                  HomeCustomPage(provider.getTabName(), (index) {
                    provider
                        .changePage(index);
                  }, provider.tabIndex),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: buildList(context, provider)))
                ],
              );
      }),
    ]);
  }

  Widget buildList(BuildContext context, AbilitiesPageProvider provider) {
    List<GuideModelDomain> list = provider.getTabData();
    return ListExpandableAbilities(list, (GuideModelDomain abilitiesModel) {
      Provider.of<AbilitiesPageProvider>(context, listen: false)
          .colapseItem(abilitiesModel);
    }, (GuideModelDomain abilitiesModel) {
      Provider.of<AbilitiesPageProvider>(context, listen: false)
          .expandItem(abilitiesModel);
    }, (GuideModelDomain abilitiesModel) {
      NavigatorUtil.pushPage(context, DetailTaskPage(abilitiesModel.id));
    });
  }
}
