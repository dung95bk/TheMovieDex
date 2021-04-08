import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/movie_detail.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';

class DetailMoviePageProvider extends ChangeNotifier {
  int currentPage = 0;
  MovieDetailModel movieDetailModel =  MovieDetailModel.empty();
  bool isLoading = false;
  int movieId;


  DetailMoviePageProvider(this.movieId) {
    initData();
  }

  void initData() async {
    final _tmdb = TMDBApi.instance;
    print('DetailMovie id: ${movieId}');
    final response =  await _tmdb.getMovieDetail(movieId,  appendtoresponse:
        'keywords,recommendations,credits,external_ids,release_dates');
    if(response.success) {
      movieDetailModel = response.result;
      notifyListeners();
    }
  }
}