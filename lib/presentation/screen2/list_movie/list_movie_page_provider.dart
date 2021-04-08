import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/util/const.dart';
import 'package:themoviedex/presentation/util/time_util.dart';

class ListMoviePageProvider extends ChangeNotifier {
  int currentPage = 0;
  ResponseModel<VideoListModel> videoListModel;
  List<VideoListResult> listTvShow = [];
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  int typeList = TYPE_LIST_MOVIE_TOP_RATED;
  ListMoviePageProvider(this.typeList);

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
    switch(typeList) {
      case TYPE_LIST_MOVIE_POPULAR: {
        videoListModel = await _tmdb.getMoviePopular(currentPage);
        break;
      }
      case TYPE_LIST_MOVIE_NOW_PLAYING: {
        videoListModel = await _tmdb.getMovieNowPlaying(currentPage);
        break;
      }
      case TYPE_LIST_MOVIE_TOP_RATED: {
        videoListModel = await _tmdb.getMovieTopRated(currentPage);
        break;
      }
      case TYPE_LIST_TVSHOW_ONTV: {
        videoListModel = await _tmdb.getTvShowOnTheAirToday(currentPage);
        break;
      }
      case TYPE_LIST_TVSHOW_POPULAR: {
        videoListModel = await _tmdb.getTvShowPopular(currentPage);
        break;
      }
      case TYPE_LIST_TVSHOW_AIRING_TODAY: {
        videoListModel = await _tmdb.getTvShowAiringToday(currentPage);
        break;
      }
      case TYPE_LIST_TVSHOW_TOPRATED: {
        videoListModel = await _tmdb.getTVShowTopRated(currentPage);
        break;
      }
    }
    isLoading = false;
    if(videoListModel.success) {
      print(videoListModel.result.totalPages.toString());
      videoListModel.result.results.forEach((element) {
        element.releaseDate =  convertTime(element.releaseDate);
      });
      listTvShow.addAll(videoListModel.result.results);
      notifyListeners();
    }
  }

}