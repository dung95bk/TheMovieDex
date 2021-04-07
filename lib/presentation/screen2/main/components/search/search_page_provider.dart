import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hive/hive.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/remote/models/models.dart';

class SearchPageProvider extends ChangeNotifier {
  bool _isEditingText = false;
  TextEditingController editingController = TextEditingController();
  String initialText = "Initial Text";
  String inputKeySearch = "";
  List<String> listSuggest = List();
  List<SearchResult> listSearchResult = List();
  SearchResultModel searchResultModel;
  bool isEnterSuggestion = false;
  SearchPageProvider() {
    listSuggest.addAll(Hive.box<String>(BoxName.BOX_SUGGEST_SEARCH).values);
    if(listSuggest.isEmpty) {
      listSuggest.add("Movies");
      listSuggest.add("TV Show");
      listSuggest.add("Upcoming Movies");
    }

  }


  void initSearchController() {
    editingController = TextEditingController(text: "");
    editingController.addListener(() {
      keySearch = editingController.text;
      notifyListeners();
    });
  }

  bool isInputingText() {
    if(isEnterSuggestion) return false;
    return editingController.text.isNotEmpty;
  }


  void search() async{

  }

  void enterSuggestion(String itemSuggest) {
    if(itemSuggest.isNotEmpty) {
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
