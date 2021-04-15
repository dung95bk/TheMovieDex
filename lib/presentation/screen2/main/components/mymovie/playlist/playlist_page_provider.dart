import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/movie_item_list_hive.dart';
import 'package:themoviedex/data/model/local/playlist_hive.dart';

class PlayListPageProvider extends ChangeNotifier {
  PlayListHive playListHive;
  String playListId;
  List<MovieItemListHive> listItem = [];

  PlayListPageProvider(String id) {
    this.playListId = id;
    initData();
  }

  void initData() {
    var box = Hive.box<PlayListHive>(BoxName.BOX_PLAYLIST);
    if(box != null) {
      playListHive = box.get(playListId);
      if(playListHive != null && playListHive.listItem != null) {
        listItem..clear();
        listItem.addAll(playListHive.listItem);
        notifyListeners();
      }
    }
  }

  String getTitle() {
    if(playListHive == null) return "";
    if(playListHive.title == null) return "";
    return playListHive.title;
  }

  void deletePlayListItem(int id, int index) {
    var box = Hive.box<PlayListHive>(BoxName.BOX_PLAYLIST);
    if(box != null) {
      playListHive = box.get(playListId);
      for(int i = 0; i < playListHive.listItem.length; i++) {
        if(id == playListHive.listItem[i].id) {
          playListHive.listItem.removeAt(index);
          listItem.removeAt(index);
          playListHive.save();
          notifyListeners();
          break;
        }
      }
    }
  }
}