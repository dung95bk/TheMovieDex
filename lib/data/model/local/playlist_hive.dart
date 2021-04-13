import 'package:hive/hive.dart';
import 'package:themoviedex/data/model/local/movie_item_list_hive.dart';
part 'playlist_hive.g.dart';
@HiveType(typeId: 6)
class PlayListHive extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  List<MovieItemListHive> listItem;

  PlayListHive(this.id, this.title, this.listItem);
}