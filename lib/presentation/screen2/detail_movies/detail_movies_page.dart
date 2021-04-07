import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:themoviedex/presentation/screen2/widgets/bottomsheet/flexible_bottom_sheet.dart';
import 'package:themoviedex/presentation/screen2/widgets/bottomsheet/flexible_bottom_sheet_route.dart';
import 'package:themoviedex/presentation/util/adapt.dart';

class DetailMoviePage extends StatefulWidget {
  DetailMoviePage({Key key}) : super(key: key);

  @override
  _DetailMoviePageState createState() {
    return _DetailMoviePageState();
  }
}

class _DetailMoviePageState extends State<DetailMoviePage> with SingleTickerProviderStateMixin{
  RubberAnimationController _controller;


  @override
  void initState() {
    _controller = RubberAnimationController(
      duration: Duration(seconds: 1),
      vsync: this, // Thanks to the mixin
    );
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) { _showSheetWithoutList();});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body:GestureDetector(
          onTap: () {
            print("click");
            _showSheetWithoutList();
          },
          child: Container(
            width: Adapt.screenW(),
            height: Adapt.screenH(),
            color: Colors.red,
            child: FlexibleBottomSheet(
              minHeight: .8,
              initHeight: 0.8,
              maxHeight: .9,
              isCollapsible: false,
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              headerBuilder: (context, offset) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
                      topRight: Radius.circular(offset == 0.8 ? 0 : 40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Header',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      Text(
                        'position $offset',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                );
              },

              anchors: [.2, 0.5, .8],
            ),
          ),
        )
      ),
    );
  }

  void _showSheetWithoutList() {
    showStickyFlexibleBottomSheet<void>(
      minHeight: .8,
      initHeight: 0.8,
      maxHeight: .9,
      headerHeight: 200,
      isCollapsible: false,
      context: context,
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
              topRight: Radius.circular(offset == 0.8 ? 0 : 40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Header',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Text(
                'position $offset',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        );
      },
      builder: (context, offset) {
        return SliverChildListDelegate(
          _getChildren(offset, isShowPosition: false),
        );
      },
      anchors: [.2, 0.5, .8],
    );
  }

  List<Widget> _getChildren(double bottomSheetOffset, {bool isShowPosition}) => <Widget>[
    if (isShowPosition)
      Text(
        'position $bottomSheetOffset',
        style: Theme.of(context).textTheme.headline6,
      ),
    _buildTextField(),
    _testContainer(const Color(0xEEFFFF00)),
    _buildTextField(),
    _testContainer(const Color(0xDD99FF00)),
    _buildTextField(),
    _testContainer(const Color(0xCC00FFFF)),
    _buildTextField(),
    _testContainer(const Color(0xBB555555)),
    _buildTextField(),
    _testContainer(const Color(0xAAFF5555)),
    _buildTextField(),
    _testContainer(const Color(0x9900FF00)),
    _buildTextField(),
    _testContainer(const Color(0x8800FF00)),
    _buildTextField(),
    _testContainer(const Color(0x7700FF00)),
    _buildTextField(),
  ];

  Widget _testContainer(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: color,
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
      ) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
              padding: const EdgeInsets.all(0),
              controller: scrollController,
              children: _getChildren(bottomSheetOffset, isShowPosition: true)),
        ),
      ),
    );
  }

  Widget _buildTextField() => const TextField(
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Enter a search term',
    ),
  );
}