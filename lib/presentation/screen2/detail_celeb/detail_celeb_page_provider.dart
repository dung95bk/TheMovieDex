import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/external_id_models.dart';
import 'package:themoviedex/data/remote/models/external_ids_model.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/acting_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCelebPageProvider extends ChangeNotifier {
  PeopleDetailModel peopleDetailModel = PeopleDetailModel.empty();
  ExternalIdModels externalIdsModel = ExternalIdModels.empty();
  bool isLoading = false;
  int celebId;
  List<CombinedCastData> listKnowForAll = List<CombinedCastData>();
  List<ActingModel> listActing = List<ActingModel>();

  DetailCelebPageProvider(this.celebId) {
    loadDetail();
  }

  void loadDetail() async {
    final _tmdb = TMDBApi.instance;
    ResponseModel<PeopleDetailModel> response =
    await _tmdb.getPeopleDetail(celebId, appendToResponse: 'images');
    if(response.success) {
      peopleDetailModel = response.result;
      var _combinedCredits = await _tmdb.getCombinedCredits(celebId);

      if (_combinedCredits.success) {
        var cast = [];
        cast = []..addAll(_combinedCredits.result.cast);
        cast.sort((a, b) => b.voteCount.compareTo(a.voteCount));
        _combinedCredits.result.cast = []
          ..addAll(_combinedCredits.result.cast);
        _combinedCredits.result.cast.sort((a, b) {
          String date1 = a.mediaType == 'movie' ? a.releaseDate : a
              .firstAirDate;
          String date2 = b.mediaType == 'movie' ? b.releaseDate : b
              .firstAirDate;
          date1 =
          date1 == null || date1?.isEmpty == true ? '2099-01-01' : date1;
          date2 =
          date2 == null || date2?.isEmpty == true ? '2099-01-01' : date2;
          DateTime time1 = DateTime.parse(date1);
          DateTime time2 = DateTime.parse(date2);
          return time2.year == time1.year
              ? (time2.month > time1.month ? 1 : -1)
              : (time2.year > time1.year ? 1 : -1);
        });

        var _model = _combinedCredits.result.cast ?? [];
        listKnowForAll.addAll(_model);
        var movies = _model.where((d) => d.mediaType == 'movie').toList();
        var tvshows = _model.where((d) => d.mediaType == 'tv').toList();
        for(int index = 0; index < listKnowForAll.length; index++) {

          String date = listKnowForAll[index].mediaType == 'movie'
              ? listKnowForAll[index].releaseDate
              : listKnowForAll[index].firstAirDate;
          date = date == null || date?.isEmpty == true
              ? '-'
              : DateTime.parse(date).year.toString();
          String title = listKnowForAll[index].title ?? listKnowForAll[index].name;
          if(listActing.isEmpty) {
            listActing.add(ActingModel(date, title));
          } else {
            ActingModel lastItem = listActing.last;
            if(index > 0 && lastItem.year == date) {
              lastItem.tilte += "\n\n" +  title;
            } else {
              listActing.add(ActingModel(date, title));
            }
          }
        }

        notifyListeners();

      }
      var responseExternalIds = await _tmdb.getExternalIds(celebId);
      print("CelebDI ${celebId}");

      if(responseExternalIds.success) {
        externalIdsModel = responseExternalIds.result;
      }
      notifyListeners();
    }
  }

  String getThumbCeleb() {
    return peopleDetailModel == null ? "" : peopleDetailModel.profilePath;
  }

  void launchUrl(String url) async {
    print("A");
    if(url != null) {
      print("B");
      if (await canLaunch(url)) {
        print("C");
        await launch(url);
      } else {
        print("couldn't launch ${url}");
      }
    }
  }
}