import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';

double ourMap(v, start1, stop1, start2, stop2) {
  return (v - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}

class HomeCustomPage extends StatefulWidget {
  List<String> tabs = List<String>();

  ValueChanged<int> onTap;
  int currentTab;


  HomeCustomPage(this.tabs, this.onTap, this.currentTab);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeCustomPage>
    with SingleTickerProviderStateMixin {
  final int initPage = 0;
  List<String> tabs= List<String>();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    this.currentPage = widget.currentTab;
    tabs.addAll(widget.tabs);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 40,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tabs.map((t) {
                  int index = tabs.indexOf(t);
                  return Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = index;
                            if(widget.onTap != null) widget.onTap(index);
                          });
                        },
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Colors.deepOrange
                                  : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: kThemeAnimationDuration,
                                style: TextStyle(
                                  inherit: true,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                                child: Text(t),
                              ),
                            )),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
