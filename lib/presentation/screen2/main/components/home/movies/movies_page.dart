import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page.dart';
import 'package:themoviedex/presentation/screen2/list_movie/list_movie_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/slider_custom_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/slider_custom_widget_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/const.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({Key key}) : super(key: key);

  @override
  _MoviesPageState createState() {
    return _MoviesPageState();
  }
}

class _MoviesPageState extends State<MoviesPage> {
  double marginList;
  double itemRowCategory;
  double itemTopRatedWidth;
  double itemTopRatedImageWidth;
  double itemTopRatedImageHeight;
  double itemTopRatedHeight;
  Widget slider;
  SliderCustomWidgetProvider provider;

  @override
  void initState() {
    super.initState();
    marginList = Adapt.px(20);
    itemRowCategory = (Adapt.screenW() - marginList * 2) / 2;
    itemTopRatedWidth = Adapt.screenW() - marginList * 2;
    itemTopRatedImageWidth = itemTopRatedWidth / 5;
    itemTopRatedHeight = itemTopRatedWidth / 3;
    itemTopRatedImageHeight = itemTopRatedHeight * 0.8;
    provider = SliderCustomWidgetProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("revuild");
    return Consumer(
      child: buildSlider(provider),
      builder: (context, MoviesPageProvider provider, child) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: provider.listTopRatedMovies.length == 0
                ? 3 + 3
                : provider.listTopRatedMovies.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return child;
              } else if (index == 1) {
                return buildRowCategory();
              } else if (index == 2) {
                return buildTopRateTitle();
              } else if (provider.listTopRatedMovies.length == 0) {
                int listTopRateIndex = index - 3;
                return buildShimmerItemTopRated(listTopRateIndex, 3);
              } else {
                int listTopRateIndex = index - 3;
                return buildItemTopRated(
                    provider.listTopRatedMovies[listTopRateIndex],
                    listTopRateIndex,
                    provider.listTopRatedMovies.length);
              }
            },
          ),
        );
      },
    );
  }

  Widget buildTopRateTitle() {
    return Container(
      margin: EdgeInsets.only(
          left: marginList, right: marginList, top: 50, bottom: 20),
      child: Row(
        children: [
          Image.asset(
            R.img_ic_toprate_movie,
            width: 33,
            height: 36,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "Top Rated Movies",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              NavigatorUtil.pushPage(
                  context,
                  ListMoviePage(
                    title: "Top Rated Movies",
                    typeList: TYPE_LIST_MOVIE_TOP_RATED,
                  ));
            },
            child: Image.asset(
              R.img_ic_seemore,
              width: 36,
              height: 25,
            ),
          )
        ],
      ),
    );
  }

  BorderRadius buildBackgroundItemTopRate(int index, int listLength) {
    bool isLast = false;
    bool isFirst = false;
    if (index == 0) {
      isFirst = true;
    } else if (index == listLength - 1) {
      isLast = true;
    }
    BorderRadius backgroundItem = BorderRadius.all(Radius.circular(0));
    if (isLast && isFirst) {
      backgroundItem = BorderRadius.all(Radius.circular(20));
    } else if (isFirst) {
      backgroundItem = BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20));
    } else if (isLast) {
      backgroundItem = BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20));
    }
    return backgroundItem;
  }

  Widget buildShimmerItemTopRated(int index, int listLength) {
    EdgeInsets margin = EdgeInsets.only(left: marginList, right: marginList);
    if (index == 0) {
      margin = EdgeInsets.only(left: marginList, right: marginList, top: 40);
    } else if (index == listLength - 1) {
      margin = EdgeInsets.only(left: marginList, right: marginList, bottom: 40);
    }
    return Shimmer.fromColors(
      baseColor: AppTheme.bottomNavigationBarBackgroundt,
      highlightColor: AppTheme.item_list_background,
      child: Container(
          width: itemTopRatedWidth,
          height: itemTopRatedHeight,
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: margin,
          decoration: BoxDecoration(
              color: AppTheme.bottomNavigationBarBackgroundt,
              borderRadius: buildBackgroundItemTopRate(index, listLength)),
          child: Row(
            children: [
              Container(
                height: itemTopRatedImageHeight,
                width: itemTopRatedImageWidth,
                decoration: BoxDecoration(
                    color: AppTheme.item_list_background,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: itemTopRatedImageWidth / 2,
                      height: 20,
                      color: AppTheme.item_list_background,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: itemTopRatedWidth / 2,
                      height: 20,
                      color: AppTheme.item_list_background,
                    ),
                  ],
                ),
              ),
              buildTopRatedRank(index)
            ],
          )),
    );
  }

  Widget buildItemTopRated(
      VideoListResult itemData, int index, int listLength) {
    EdgeInsets margin = EdgeInsets.only(left: marginList, right: marginList);
    if (index == 0) {
      margin = EdgeInsets.only(left: marginList, right: marginList, top: 40);
    } else if (index == listLength - 1) {
      margin = EdgeInsets.only(left: marginList, right: marginList, bottom: 40);
    }
    return GestureDetector(
      onTap: () {
        NavigatorUtil.pushPage(context, DetailMoviePage(movieId: itemData.id, movieType: "movie",));
      },
      child: Container(
          width: itemTopRatedWidth,
          height: itemTopRatedHeight,
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: margin,
          decoration: BoxDecoration(
              color: AppTheme.bottomNavigationBarBackgroundt,
              borderRadius: buildBackgroundItemTopRate(index, listLength)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                    imageUrl:
                        ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
                    fit: BoxFit.cover,
                    height: itemTopRatedImageHeight,
                    width: itemTopRatedImageWidth,
                    placeholder: (context, url) => Image.asset(
                          R.img_image_thumb,
                          height: itemTopRatedImageHeight,
                          width: itemTopRatedImageWidth,
                          fit: BoxFit.cover,
                        ),
                    errorWidget: (context, url, error) => Image.asset(
                          R.img_image_thumb,
                          height: itemTopRatedImageHeight,
                          width: itemTopRatedImageWidth,
                          fit: BoxFit.cover,
                        )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          itemData.title,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "${itemData.releaseDate}",
                          style: TextStyle(color: Color(0xffc9cbcd)),
                        )),
                  ],
                ),
              ),
              buildTopRatedRank(index)
            ],
          )),
    );
  }

  Widget buildTopRatedRank(int index) {
    if (index == 0) {
      return Image.asset(
        R.img_ic_topone,
        width: 40,
        height: 40,
      );
    } else if (index == 1 || index == 2) {
      return Container(
        alignment: Alignment.center,
        width: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.bg_rank_top_rate),
        child: Text(
          "${index + 1}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: AppTheme.bg_rank_top_rate),
        ),
        child: Text(
          "${index + 1}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  Widget buildRowCategory() {
    return Container(
      margin: EdgeInsets.only(left: marginList, right: marginList, top: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                NavigatorUtil.pushPage(
                    context,
                    ListMoviePage(
                      title: "Now Playing Movies",
                      typeList: TYPE_LIST_MOVIE_NOW_PLAYING,
                    ));
              },
              child: Image.asset(
                R.img_ic_nowplay,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                NavigatorUtil.pushPage(
                    context,
                    ListMoviePage(
                      title: "Popular Movies",
                      typeList: TYPE_LIST_MOVIE_POPULAR,
                    ));
              },
              child: Image.asset(
                R.img_ic_popularmovie,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSlider(SliderCustomWidgetProvider provider) {
    print("buildSlider");

    return SliderCustomWidget(
      provider: provider,
      onItemClick: (int id) {
        NavigatorUtil.pushPage(context, DetailMoviePage(movieId: id, movieType: "movie",));
      },
    );
  }
}
