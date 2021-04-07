import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/item_tv_show_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page_provider.dart';
import 'package:themoviedex/presentation/screen2/voice_search/voice_search_page.dart';
import 'package:themoviedex/presentation/screen2/widgets/clear_focus_gesture.dart';
import 'package:themoviedex/presentation/screen2/widgets/loading/color_loader3.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/const.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  SearchPageProvider provider;
  FocusNode inputFocusNode = FocusNode(debugLabel: 'Close Backdrop Button');

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SearchPageProvider>(context, listen: false);
    provider.initSearchController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("search :dispose");
    inputFocusNode.dispose();
    provider.editingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    print("search :didChangeDependencies");
  }


  @override
  void setState(VoidCallback fn) {
    print("search :setState");
  }

  @override
  void deactivate() {
    print("search :deactivate");
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("search :resumed");
        break;
      case AppLifecycleState.inactive:
        print("search :inactive");
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        FocusManager.instance.primaryFocus.unfocus();

        print("search :paused");
        // widget is paused
        break;
      case AppLifecycleState.detached:
        print("search :detached");

        // widget is detached
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Consumer(
          builder: (context, SearchPageProvider provider, child) {
            return Column(
              children: [
                buildSearchInput(),
                Expanded(child: GestureDetector(onTap: () {
                  inputFocusNode.unfocus();
                }, child: buildContent(provider))),
              ],
            );
          },
        ),
      );

  }

  Widget buildContent(SearchPageProvider provider) {
    if (provider.isShowSuggest) {
      return buildSuggestion(provider);
    } else if (provider.isShowLoading) {
      return buildLoading();
    } else {
      if (provider.listSearchResult.isNotEmpty) {
        return buildList();
      } else {
        return buildEmptyList();
      }
    }
  }

  Widget buildLoading() {
    return ColorLoader3(radius: 30, dotRadius: 3,);
  }

  Widget buildSuggestion(SearchPageProvider provider) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        itemCount: provider.listSuggest.length,
        itemBuilder: (context, index) {
          String itemSuggest = provider.listSuggest[index];
          return ClearFocusGestureDetector(
            onTap: () {
              provider.enterSuggestion(itemSuggest);
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                itemSuggest,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildEmptyList() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text(
        "Not found",
        style: TextStyle(
            color: Colors.white,
            fontSize: 30
        ),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      controller: provider.scrollController,
      itemCount: provider.listSearchResult.length,
      itemBuilder: (context, index) {
        SearchResult searchResult = provider.listSearchResult[index];
        return ItemTVShowWidget(
          isTvShow: searchResult.mediaType == "tv",
          itemData: searchResult,
        );
      },
    );
  }

  Widget buildSearchInput() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: AppTheme.bottomNavigationBarBackgroundt,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search movies, TV show…",
                          hintStyle:
                          TextStyle(color: Color(0xFF666F7A), fontSize: 16),
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                        ),

                        style: TextStyle(color: Colors.white),
                        controller: provider.editingController,
                        onSubmitted: (newValue) {},
                        autofocus: false,
                        focusNode: inputFocusNode,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    provider.isEnterSuggestion
                        ? ClearFocusGestureDetector(
                      onTap: () {
                        provider.clearSuggestion();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppTheme.item_list_background,
                      ),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Center(
                  child: provider.isInputingText()
                      ? ClearFocusGestureDetector(
                    onTap: () {
                      provider.clearSuggestion();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: AppTheme.bg_rank_top_rate,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                      : (!provider.isEnterSuggestion
                      ? ClearFocusGestureDetector(
                    onTap: () {
                      showVoiceSearchPage();
                    },
                    child: Image.asset(
                      R.img_ic_search_voice,
                      width: 50,
                      height: 50,
                    ),
                  )
                      : SizedBox())),
            )
          ],
        ),
      ),
    );
  }

  void showVoiceSearchPage() async {
    final result = await NavigatorUtil.pushPage(context, VoiceSearchPage());
    if (result != null && result is String) {
      setState(() {
        provider.enterSuggestion(result);
      });
    }
  }
}

