import 'package:flutter/material.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/util/screen_util.dart';
import 'package:tuple/tuple.dart';

class TabSlideChooseWallpaper extends StatefulWidget {
  final ValueChanged<int> selection;
  final List<String> names;

  TabSlideChooseWallpaper(Key key, this.names, this.selection) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TabSlideChooseWallpaperState();
  }
}

class TabSlideChooseWallpaperState extends State<TabSlideChooseWallpaper> {
  var _selected = 0;
  List<Tab> rows = [];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final Tuple2 screenSize = getScreenSize(context);

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: DefaultTabController(
        length: widget.names.length,
        child: TabBar(
          physics:
          BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFFFF8900)),
          tabs: _tabs(widget.names, screenSize.item1),
          onTap: (value) {
            setState(() {
              _selected = value;
              widget.selection(value);
            });
          },
        ),
      ),
    );
  }

  void setPage(int index) {
    setState(() {
      _selected = index;
    });
  }

  List<Tab> _tabs(List<String> names, double width) {
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
                    Image.asset(
                      R.img_ic_guide,
                      fit: BoxFit.fitWidth,
                    ),
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
}
