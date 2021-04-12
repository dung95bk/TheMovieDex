import 'package:hive/hive.dart';
part 'favorite_movie_hive.g.dart';

@HiveType(typeId: 5)
class FavoriteMovieHive extends HiveObject {
  @HiveField(10)
  int id;
  @HiveField(11)
  String title;
  @HiveField(12)
  String date;
  @HiveField(13)
  String posterPath;
  FavoriteMovieHive(this.id, this.title, this.date, this.posterPath);
}