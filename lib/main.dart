import 'package:flutter/material.dart';
import 'package:themoviedex/data/config/LocalConfig.dart';
import 'package:themoviedex/data/config/ServerConfig.dart';
import 'package:themoviedex/data/model/local/favorite_movie_hive.dart';
import 'package:themoviedex/data/model/local/movie_item_list_hive.dart';
import 'package:themoviedex/data/model/local/playlist_hive.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/route/route_handler.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:themoviedex/presentation/screen2/main/components/celeb/celeb_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/home_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/mymovie/my_movie_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/main_page_provider.dart';
import 'package:themoviedex/presentation/screen2/splash/splash_page.dart';
import 'package:themoviedex/presentation/screen2/testads/myapp.dart';

import 'data/helper/box_name.dart';

Future<void> main()  async {
  Hive.registerAdapter(FavoriteMovieHiveAdapter());
  Hive.registerAdapter(PlayListHiveAdapter());
  Hive.registerAdapter(MovieItemListHiveAdapter());

  await Hive.initFlutter();
  await Hive.openBox<FavoriteMovieHive>(BoxName.BOX_FAV_MOVIE);
  await Hive.openBox<PlayListHive>(BoxName.BOX_PLAYLIST);
  await Hive.openBox<MovieItemListHive>(BoxName.BOX_ITEM_PLAYLIST);
  await Hive.openBox<String>(BoxName.BOX_SUGGEST_SEARCH);



  runApp(MultiProvider(
    providers: [
      //New
      ChangeNotifierProvider(create: (_) => MainPageProvider(),),
      ChangeNotifierProvider(create: (_) => CelebPageProvider(),),
      ChangeNotifierProvider(create: (_) => HomePageProvider(),),
      ChangeNotifierProvider(create: (_) => MyMovieProvider(),),
      ChangeNotifierProvider(create: (_) => SearchPageProvider(),),
      ChangeNotifierProvider(create: (_) => TvShowPageProvider(),),
      ChangeNotifierProvider(create: (_) => MoviesPageProvider(),),
    ],
    child: MyApp(),
  ));}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
    _init();

  }
  Future _init() async {
    print("init MyApp");
    await LocalConfig.instance.init(context);
    await ServerConfig.instance.init(context);
    await TMDBApi.instance.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie Dex',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.black,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          accentColor: Colors.black,
        bottomSheetTheme:  BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: MyTestApp(),
      onGenerateRoute: routeHandler,
    );
  }
}