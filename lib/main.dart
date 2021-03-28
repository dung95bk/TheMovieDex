import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:themoviedex/data/config/LocalConfig.dart';
import 'package:themoviedex/data/config/ServerConfig.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/remote/tmdb_api.dart';
import 'package:themoviedex/presentation/custom_widgets/test_page_filter.dart';
import 'package:themoviedex/presentation/route/route_handler.dart';
import 'package:themoviedex/presentation/screen/abilities/abilities_page_provider.dart';
import 'package:themoviedex/presentation/screen/category/category_provider.dart';
import 'package:themoviedex/presentation/screen/colors/colors_page_provider.dart';
import 'package:themoviedex/presentation/screen/detail_task/detail_task_provider.dart';
import 'package:themoviedex/presentation/screen/groups/groups_provider.dart';
import 'package:themoviedex/presentation/screen/guide_page/guide_provider.dart';
import 'package:themoviedex/presentation/screen/home/home_provider.dart';
import 'package:themoviedex/presentation/screen/listwallpaper/list_wallpaper_provider.dart';
import 'package:themoviedex/presentation/screen/location/location_page_provider.dart';
import 'package:themoviedex/presentation/screen/map/map_page_provider.dart';

import 'package:themoviedex/presentation/screen/tasks/task_page_provider.dart';
import 'package:themoviedex/presentation/screen/wallpaper_page/wallpaper_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:themoviedex/presentation/screen2/main/components/celeb/celeb_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/home_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/mymovie/my_movie_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/main_page_provider.dart';
import 'package:themoviedex/presentation/screen2/splash/splash_page.dart';
import 'package:themoviedex/presentation/screen2/splash/splash_provider.dart';

import 'data/helper/box_name.dart';
void configLoading() {
  EasyLoading.instance

    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(ImageModeHiveAdapter());
  await Hive.initFlutter();
  await Hive.openBox<ImageModeHive>(BoxName.BOX_IMAGE);
  await Hive.openBox<String>(BoxName.BOX_DOWNLOADED_IMAGE_PATH);



  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider(),),
      ChangeNotifierProvider(create: (_) => WallpaperProvider(),),
      ChangeNotifierProvider(create: (_) => GuideProvider(),),
      ChangeNotifierProvider(create: (_) => GroupsProvider(),),
      ChangeNotifierProvider(create: (_) => ColorsPageProvider(),),
      ChangeNotifierProvider(create: (_) => AbilitiesPageProvider(),),
      ChangeNotifierProvider(create: (_) => CategoryProvider(),),
      ChangeNotifierProvider(create: (_) => ListWallpaperProvider(),),
      ChangeNotifierProvider(create: (_) => LocationPageProvider(),),
      ChangeNotifierProvider(create: (_) => MapPageProvider(),),
      ChangeNotifierProvider(create: (_) => TaskPageProvider(),),
      ChangeNotifierProvider(create: (_) => SplashProvider(),),
      ChangeNotifierProvider(create: (_) => GuideProvider(),),

      //New
      ChangeNotifierProvider(create: (_) => MainPageProvider(),),
      ChangeNotifierProvider(create: (_) => CelebPageProvider(),),
      ChangeNotifierProvider(create: (_) => HomePageProvider(),),
      ChangeNotifierProvider(create: (_) => MyMovieProvider(),),
      ChangeNotifierProvider(create: (_) => SearchPageProvider(),),
      ChangeNotifierProvider(create: (_) => TvShowPageProvider(),),


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
    _init();

    super.initState();

  }
  Future _init() async {
    print("init MyApp");
    await LocalConfig.instance.init(context);
    await ServerConfig.instance.init(context);
    await TMDBApi.instance.init();
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
          primarySwatch: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.black,
          accentColor: Colors.black
      ),
      home: SplashPage(),
      onGenerateRoute: routeHandler,
    );
  }
}