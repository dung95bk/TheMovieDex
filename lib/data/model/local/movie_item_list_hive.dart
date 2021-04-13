import 'package:hive/hive.dart';
part 'movie_item_list_hive.g.dart';
@HiveType(typeId: 7)
class MovieItemListHive extends HiveObject {
  @HiveField(10)
  int id;
  @HiveField(11)
  String title;
  @HiveField(12)
  String date;
  @HiveField(13)
  String posterPath;
  MovieItemListHive(this.id, this.title, this.date, this.posterPath);
}