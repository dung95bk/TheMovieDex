import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';

class MoviesPageProvider extends ChangeNotifier {
  int currentPage = 0;
  ResponseModel<VideoListModel> videoListModel;
  List<VideoListResult> listMovies = [];
  ResponseModel<VideoListModel> topRatedListModel;
  List<VideoListResult> listTopRatedMovies = [];

  bool isLoadingMovies = false;
  bool isLoadingTopRate = false;

  MoviesPageProvider() {

  }

  void getMovie() async {

}
