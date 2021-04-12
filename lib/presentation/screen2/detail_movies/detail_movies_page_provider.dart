import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/image_model.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/data/remote/models/movie_detail.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'file:///C:/Users/Admin/AndroidStudioProjects/themoviedex/lib/data/model/local/favorite_movie_hive.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/videourl.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMoviePageProvider extends ChangeNotifier {
  int currentPage = 0;
  MovieDetailModel movieDetailModel = MovieDetailModel.empty();
  ImageModel imageModel = ImageModel.empty();
  List<VideoResult> listVideo = [];
  bool isLoading = false;
  int movieId;

  // VideoPlayerController videoPlayerController;
  // ChewieController chewieController;
  YoutubePlayerController youtubePlayerController;
  String videoId = '';
  bool playVideo = false;

  bool isHasVideoData = false;
  bool isHasImageData = false;
  bool isShowTrailerLayout = false;
  bool isFavorite = false;

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
      isHasImageData = true;
      isFav();
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

  void favorite() {
    if (movieDetailModel == null) return;
    var boxMovie = Hive.box<FavoriteMovieHive>(BoxName.BOX_FAV_MOVIE);
    var foundMovie = boxMovie.get(movieDetailModel.id);
    if (foundMovie == null) {
      boxMovie.put(
          movieDetailModel.id,
          FavoriteMovieHive(movieDetailModel.id, movieDetailModel.originalTitle,
              movieDetailModel.releaseDate, movieDetailModel.posterPath));
      isFavorite = true;
    } else {
      foundMovie.delete();
      isFavorite = false;
    }
    notifyListeners();
  }

  bool isFav() {
    var boxMovie = Hive.box<FavoriteMovieHive>(BoxName.BOX_FAV_MOVIE);
    var foundMovie = boxMovie.get(movieDetailModel.id);
    return foundMovie == null;
  }

  void getVideo() async {
    final _tmdb = TMDBApi.instance;
    final responseVideo = await _tmdb.getMovieVideo(movieId);
    if (responseVideo.success &&
        responseVideo.result != null &&
        responseVideo.result.results != null) {
      listVideo.addAll(responseVideo.result.results);
      if (listVideo.isNotEmpty) {
        final url = VideoUrl.getUrl(listVideo[0].key, listVideo[0].site);
        print("${url}");
        // videoPlayerController = VideoPlayerController.network(
        //     "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
        // chewieController = new ChewieController(
        //   videoPlayerController: videoPlayerController,
        //   aspectRatio: 16 / 9,
        // );
        videoId = listVideo[0].key;
        youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
        );
        isHasVideoData = true;
      }
      notifyListeners();
    }
  }

  startPlayVideo(bool play) {
    if (isHasVideoData) {
      if (!play) {
        youtubePlayerController.reset();
        youtubePlayerController.reload();
      } else {
        print("play");
        youtubePlayerController.play();
      }
      playVideo = play;
      notifyListeners();
    }
  }

  showTrailerLayout() {
    if (!isHasVideoData) return;
    print("showTrailerLayout");
    startPlayVideo(true);
    isShowTrailerLayout = true;
  }

  hideTrailerLayout() {
    print("showTrailerLayout");
    youtubePlayerController.pause();
    isShowTrailerLayout = false;
    notifyListeners();
  }

  String getThumbVideo() {
    if (imageModel.backdrops != null && imageModel.backdrops.length > 0) {
      return ImageUrl.getUrl(imageModel.backdrops[0].filePath, ImageSize.w300);
    } else {
      return "";
    }
  }
}
