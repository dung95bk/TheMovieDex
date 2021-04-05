import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/item_tv_show_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/list_movie/list_movie_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page_provider.dart';
import 'package:themoviedex/presentation/screen2/voice_search/voice_search_page.dart';
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

class _SearchPageState extends State<SearchPage> {
  bool isShowSuggest = true;
  SearchPageProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SearchPageProvider>(context, listen: false);
    provider.initSearchController();
  }

  @override
  void dispose() {
    provider.editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, SearchPageProvider provider, child) {
          return Column(
            children: [
              buildSearchInput(),
              isShowSuggest ? buildSuggestion(provider) : buildList(),
            ],
          );
        },
      ),
    );
  }

  Widget buildSuggestion(SearchPageProvider provider) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
          itemCount: provider.listSuggest.length,
          itemBuilder: (context, index) {
            String itemSuggest = provider.listSuggest[index];
            return GestureDetector(
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
      ),
    );
  }

  Widget buildList() {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.listSearchResult.length,
        itemBuilder: (context, index) {
          SearchResult searchResult = provider.listSearchResult[index];
          return ItemTVShowWidget(
            isTvShow: true,
            itemData: searchResult,
          );
        },
      ),
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
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    provider.isEnterSuggestion
                        ? GestureDetector(
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
                      ? GestureDetector(
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
                          ? GestureDetector(
                              onTap: () {
                                NavigatorUtil.pushPage(context, VoiceSearchPage());
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
}
