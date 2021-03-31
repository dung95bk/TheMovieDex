import 'package:flutter/material.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class TabbarListMovieWidget extends StatefulWidget {
  ValueChanged<bool> isGrid;

  TabbarListMovieWidget({Key key, this.isGrid}) : super(key: key);

  @override
  _TabbarHomeWidgetState createState() {
    return _TabbarHomeWidgetState();
  }
}

class _TabbarHomeWidgetState extends State<TabbarListMovieWidget> {
  int selectedIndex = 0;
  List<Tab> rows = [];
  bool isGrid = false;

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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black)],
        color: Colors.grey.withAlpha(100),
        borderRadius: BorderRadius.circular(40),
      ),
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.only(left: 2, right: 2),
          onTap: (int index) {
            if (index == 0) {
              isGrid = true;
            } else {
              isGrid = false;
            }
            widget.isGrid(isGrid);
            setState(() {

            });
          },
          indicator: BoxDecoration(
            color: Colors.red.shade900,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5.0,
                  offset: Offset(1.0, 1.0))
            ],
          ),
          isScrollable: true,
          tabs: _tabs(isGrid),
        ),
      ),
    );
  }

  List<Tab> _tabs(bool isGrid) {
    rows.clear();
    rows.add(
      Tab(
          child: Container(
            padding: EdgeInsets.all(10),
        width: 40,
        height: 40,
        child: isGrid ?  Image.asset(R.img_ic_grid_active, width: 40, height: 40,) :Image.asset(R.img_ic_grid_inactive, width: 40, height: 40,),
      )),
    );
    rows.add(
      Tab(
          child: Container(
            padding: EdgeInsets.all(10),
        width: 40,
        height: 40,
            child: isGrid ?  Image.asset(R.img_ic_list_inactive, width: 40, height: 40,) :Image.asset(R.img_ic_list_active, width: 40, height: 40,),
      )),
    );
    return rows;
  }
}
