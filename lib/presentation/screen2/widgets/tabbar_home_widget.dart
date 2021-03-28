import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class TabbarHomeWidget extends StatefulWidget {
  PageController pageController;
  TabbarHomeWidget({Key key, @required this.pageController}) : super(key: key);

  @override
  _TabbarHomeWidgetState createState() {
    return _TabbarHomeWidgetState();
  }
}

class _TabbarHomeWidgetState extends State<TabbarHomeWidget> {
  int selectedIndex = 0;
  List<String> names = [];
  Widget pageCategory;
  Widget pageListHot;

  List<Tab> rows = [];

  @override
  void initState() {
    super.initState();
    names.add("Movie");
    names.add("TV Show");
    pageCategory = MoviesPage();
    pageListHot = TvShowPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = 'TV Show';
    final style = TextStyle( fontSize: 16,
      fontWeight: FontWeight.w700,);

    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);
    double textPadding = Adapt.px(40) ;
    double sizeText = textPainter.size.width + textPadding * 2;
    print(textPainter.size); // Size(270.0, 43.0)
    return Center(
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(

          boxShadow: [BoxShadow(color: Colors.black)],
          color: Colors.grey.withAlpha(100),
            borderRadius: BorderRadius.circular(40),
        ),
        child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.all(0) ,
            onTap: (int index) =>
            {widget.pageController.jumpToPage(index)},
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0xFFCE0000)),
            isScrollable: true,
            tabs: _tabs(names, sizeText),
          ),
        ),
      ),
    );
  }

  List<Tab> _tabs(List<String> names, double sizeText) {
    rows.clear();
    for (var tab = 0; tab < names.length; tab++) {
      rows.add(
        Tab(
            child: Container(
              width: sizeText,
              child: Text(
                names[tab],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )),
      );
    }
    return rows;
  }
}