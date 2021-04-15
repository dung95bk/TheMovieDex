import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/favorite_movie_hive.dart';
import 'package:themoviedex/data/model/local/playlist_hive.dart';

class MyMovieProvider extends ChangeNotifier {
  List<PlayListHive> listPlayList = [];
  List<FavoriteMovieHive> listFavorite = [];

  void initData() {
    getListPlayList();
    getListFavorite();
    notifyListeners();
  }

  void getListPlayList() {
    listPlayList.clear();
    var box = Hive.box<PlayListHive>(BoxName.BOX_PLAYLIST);
    if(box.values.length > 0) {
      listPlayList.addAll(box.values.toList().reversed);
    }
  }

  void getListFavorite() {
    listFavorite.clear();
    var box = Hive.box<FavoriteMovieHive>(BoxName.BOX_FAV_MOVIE);
    if(box.values.length > 0) {
      listFavorite.addAll(box.values);
    }
  }

  void deleteFavorite(int id, int index) {
    var boxMovie = Hive.box<FavoriteMovieHive>(BoxName.BOX_FAV_MOVIE);
    boxMovie.delete(id);
    listFavorite.removeAt(index);
    notifyListeners();
  }

}
