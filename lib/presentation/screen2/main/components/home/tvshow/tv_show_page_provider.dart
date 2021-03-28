import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/util/time_util.dart';

class TvShowPageProvider extends ChangeNotifier {
  TvShowPageProvider();
  int currentPage = 0;
  ResponseModel<VideoListModel> videoListModel;
  List<VideoListResult> listTvShow = [];
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  void initData() async {
    addScrollListener();
    loadTvShow();
  }
  
  void addScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("loadmore ${currentPage}");
        if (!isLoading && currentPage < videoListModel.result.totalPages) {
          loadTvShow();
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

  void loadTvShow() async {
    final _tmdb = TMDBApi.instance;
    isLoading = true;
    currentPage += 1;

    videoListModel = await _tmdb.getTVDiscover(
      page: currentPage,
      sortBy: "popularity.desc",
    );
    isLoading = false;
    if(videoListModel.success) {
      print(videoListModel.result.totalPages.toString());
      videoListModel.result.results.forEach((element) {
        element.firstAirDate =  convertTime(element.firstAirDate);
      });
      listTvShow.addAll(videoListModel.result.results);
      notifyListeners();
    }
  }
}
