import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/util/time_util.dart';

class MoviesPageProvider extends ChangeNotifier {
  int currentPage = 0;

  ResponseModel<VideoListModel> topRatedListModel;
  List<VideoListResult> listTopRatedMovies = [];


  bool isLoading = false;

  MoviesPageProvider() {
    getMovie();
  }


  void getMovie() async {
    final _tmdb = TMDBApi.instance;
    isLoading = true;
    currentPage += 1;

    topRatedListModel = await _tmdb.getMovieTopRated(currentPage);
    isLoading = false;
    if(topRatedListModel.success) {
      print(topRatedListModel.result.results[0].releaseDate);
      topRatedListModel.result.results.forEach((element) {
        element.releaseDate =  convertTime(element.releaseDate);
      });
      listTopRatedMovies.addAll(topRatedListModel.result.results);
      notifyListeners();

    } else {
      print(topRatedListModel.message);
    }
  }
}
