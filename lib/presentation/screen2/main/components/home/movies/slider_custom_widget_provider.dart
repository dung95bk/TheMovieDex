import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/enums/media_type.dart';
import 'package:themoviedex/data/remote/models/enums/time_window.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/search_result.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/util/time_util.dart';

class SliderCustomWidgetProvider extends ChangeNotifier {
  int currentPage = 0;
  ResponseModel<VideoListModel> videoListModel;
  List<VideoListResult> listMovies = [];
  PageController pageController = PageController(viewportFraction: 0.7);
  bool isLoading = false;

  SliderCustomWidgetProvider() {
    getMovie();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void getMovie() async {
    final _tmdb = TMDBApi.instance;
    isLoading = true;
    currentPage += 1;
    // videoListModel = await _tmdb.getMovieUpComing(page: currentPage);
    videoListModel = await _tmdb.getMovieTopRated(currentPage);
    isLoading = false;
    if(videoListModel.success) {
      print(videoListModel.result.results);
      videoListModel.result.results.forEach((element) {
        element.releaseDate =  convertTime(element.releaseDate);
      });
      listMovies.addAll(videoListModel.result.results);
      notifyListeners();

    } else {
      print(videoListModel.message);
    }
  }
}