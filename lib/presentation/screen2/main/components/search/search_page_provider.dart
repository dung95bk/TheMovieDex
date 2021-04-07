import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/multi_type_model.dart';
import 'package:themoviedex/presentation/util/adapt.dart';

class SearchPageProvider extends ChangeNotifier {
  bool _isEditingText = false;
  TextEditingController editingController = TextEditingController();
  String initialText = "Initial Text";
  String inputKeySearch = "";
  List<String> listSuggest = List();
  List<SearchResult> listSearchResult = List();
  SearchResultModel searchResultModel;
  bool isEnterSuggestion = false;
  bool isShowSuggest = true;
  bool isShowLoading = false;
  PublishSubject<String> queryTask;
  String lastSearchedKey = "";
  int currentPage = 1;
  int totalPage = 2;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  SearchPageProvider() {
    listSuggest.addAll(Hive.box<String>(BoxName.BOX_SUGGEST_SEARCH).values);
    if (listSuggest.isEmpty) {
      listSuggest.add("Movies");
      listSuggest.add("TV Show");
      listSuggest.add("Upcoming Movies");
    }
    addScrollListener();
    queryTask = new PublishSubject<String>();
    queryTask
        .debounceTime(Duration(seconds: 1))
        .distinct()
        .switchMap((value) async* {
      print("Searching..${inputKeySearch}");
      if(lastSearchedKey != inputKeySearch) {
        listSearchResult.clear();
        currentPage = 1;
      }
      lastSearchedKey = inputKeySearch;
      notifyListeners();
      final _tmdb = TMDBApi.instance;
      yield await _tmdb.searchByKeyword(inputKeySearch, page: currentPage);
     
    }).map((event) async{
      if (event.success && event.result != null && event.result.results != null) {
        isShowSuggest = false;
        isShowLoading = false;
        totalPage = event.result.totalResults ?? 2;
        listSearchResult.addAll(event.result.results.where((element) => element.mediaType =="tv" || element.mediaType == "movie"));
        if(inputKeySearch.isNotEmpty) {
          notifyListeners();
        }
      } else {
        listSearchResult.clear();
        notifyListeners();
      }
    }).listen((event) {
     
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
     if(!visible) {
       FocusManager.instance.primaryFocus.unfocus();

     }
    });
  }

  void addScrollListener() {
    scrollController.addListener(() {
      FocusManager.instance.primaryFocus.unfocus();
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("loadmore ${currentPage}");
        if (!isLoading && currentPage < totalPage) {
          loadMore();
          // Animate to bottom of list
          Timer(Duration(milliseconds: 100), () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          });
        }
      }
    });
  }


  void loadMore() async {
    currentPage ++;
    isLoading = true;
    final _tmdb = TMDBApi.instance;
    final response = await _tmdb.searchByKeyword(inputKeySearch, page: currentPage);
    isLoading = false;
    if (response.success && response.result != null && response.result.results != null) {
      isShowSuggest = false;
      isShowLoading = false;
      totalPage = response.result.totalResults ?? 2;
      listSearchResult.addAll(response.result.results.where((element) => element.mediaType =="tv" || element.mediaType == "movie"));
      if(inputKeySearch.isNotEmpty) {
        notifyListeners();
      }
    }
  }

  void initSearchController() {
    editingController = TextEditingController(text: "");
    editingController.addListener(() {
      inputKeySearch = editingController.text;
      print("textHasFocus ${WidgetsBinding.instance.window.viewInsets.bottom}");
      if(WidgetsBinding.instance.window.viewInsets.bottom == 0) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      if (inputKeySearch.isNotEmpty) {

        if(inputKeySearch != lastSearchedKey) {
          isShowLoading = true;
          isShowSuggest = false;
          queryTask.add(inputKeySearch);
        }
      } else {
        isEnterSuggestion = false;
        isShowSuggest = true;
        currentPage = 1;
        isShowLoading = false;
        inputKeySearch = "";
        lastSearchedKey = "";
        listSearchResult.clear();
      }
      notifyListeners();
    });
  }

  bool isInputingText() {
    if (isEnterSuggestion) return false;
    return editingController.text.isNotEmpty;
  }

  void enterSuggestion(String itemSuggest) {
    print("ABC");
    if(itemSuggest.isNotEmpty) {
      print("ABC1");
      isEnterSuggestion = true;
      editingController.text = itemSuggest;
      print("enterSuggestion");
      queryTask.add(inputKeySearch);
      notifyListeners();
    }
  }

  void clearSuggestion() {
    isEnterSuggestion = false;
    isShowSuggest = true;
    currentPage = 1;
    isShowLoading = false;
    inputKeySearch = "";
    lastSearchedKey = "";
    editingController.text = "";
    listSearchResult.clear();
    notifyListeners();
  }
}
