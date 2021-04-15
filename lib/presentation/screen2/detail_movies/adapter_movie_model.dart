import 'package:themoviedex/data/remote/models/credits_model.dart';
import 'package:themoviedex/data/remote/models/movie_detail.dart';
import 'package:themoviedex/data/remote/models/tvshow_detail.dart';
import 'package:themoviedex/presentation/util/time_util.dart';

class AdapterMovieModel {
  int id;
  String title;
  String date;
  String posterPath;
  String backdropPath;
  String overview;
  CreditsModel credits;
  List<Genre> genres;
  String duration;
  bool isTvShow;
  AdapterMovieModel.empty();
  AdapterMovieModel.fromMovieModel(MovieDetailModel model) {
    id = model.id;
    title = model.originalTitle ?? "";
    date = convertTime(model.releaseDate);
    posterPath = model.posterPath;
    backdropPath = model.backdropPath;
    overview = model.overview;
    credits = model.credits;
    genres = model.genres;
    isTvShow = false;
    duration = _covertDuration(model?.runtime);
  }

  AdapterMovieModel.fromTvShowModel(TVDetailModel model) {
    id = model.id;
    title = model.name ?? "";
    date = convertTime(model.firstAirDate);
    posterPath = model.posterPath;
    backdropPath = model.backdropPath;
    overview = model.overview;
    credits = model.credits;
    genres = model.genres;
    isTvShow = true;

    duration = _convertEpisodes(model.numberOfEpisodes ?? 0, model.numberOfSeasons ?? 0);

  }

  String _convertEpisodes(int numEpisode, int numseason) {
    return "${numEpisode} Episodes/${numseason} Seasons";
  }


  String _covertDuration(int d) {
    if (d == null) {
      return "";
    }
    String result = '';
    Duration duration = Duration(minutes: d);
    int h = duration.inHours;
    int countedMin = h * 60;
    int m = duration.inMinutes - countedMin;
    result += h > 0 ? '$h h ' : '';
    result += '$m min';
    return result;
  }
}