import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/image_model.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/data/remote/models/movie_detail.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';

class DetailMoviePageProvider extends ChangeNotifier {
  int currentPage = 0;
  MovieDetailModel movieDetailModel = MovieDetailModel.empty();
  ImageModel imageModel = ImageModel.empty();
  List<VideoResult> listVideo = [];
  bool isLoading = false;
  int movieId;

  DetailMoviePageProvider(this.movieId) {
    initData();
    getImage();
    getVideo();
  }

  void initData() async {
    final _tmdb = TMDBApi.instance;
    print('DetailMovie id: ${movieId}');
    final response = await _tmdb.getMovieDetail(movieId,
        appendtoresponse:
            'keywords,recommendations,credits,external_ids,release_dates,images,movies');
    if (response.success) {
      movieDetailModel = response.result;

      notifyListeners();
    }
  }

  void getImage() async {
    final _tmdb = TMDBApi.instance;
    final responseImage = await _tmdb.getMovieImages(movieId);
    if (responseImage.success) {
      imageModel = responseImage.result;
      notifyListeners();
    }
  }

  void getVideo() async {
    final _tmdb = TMDBApi.instance;
    final responseVideo = await _tmdb.getMovieVideo(movieId);
    if (responseVideo.success &&
        responseVideo.result != null &&
        responseVideo.result.results != null) {
      listVideo.addAll(responseVideo.result.results);
      notifyListeners();
    }
  }
}
