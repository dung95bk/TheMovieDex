import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/search_result.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';

class CelebPageProvider extends ChangeNotifier {
  int currentPage = 0;
  ResponseModel<SearchResultModel> peopleListModel;
  List<SearchResult> listPeople = [];
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  CelebPageProvider();

  void initData() async {
    addScrollListener();
    loadPeopleList();
  }

  void addScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("loadmore ${currentPage}");
        if (!isLoading && currentPage < peopleListModel.result.totalPages) {
          loadPeopleList();
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

  void loadPeopleList() async {
    final _tmdb = TMDBApi.instance;
    isLoading = true;
    currentPage += 1;
    peopleListModel = await _tmdb.getPopularPerson(currentPage);
    isLoading = false;
    if(peopleListModel.success) {
      print(peopleListModel.result.totalPages.toString());
      peopleListModel.result.results.forEach((element) {

      });
      listPeople.addAll(peopleListModel.result.results);
      notifyListeners();
    }
  }
}
