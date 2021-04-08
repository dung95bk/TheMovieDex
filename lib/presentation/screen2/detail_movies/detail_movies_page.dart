import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/credits_model.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/genre.dart';
import 'package:themoviedex/data/remote/models/image_model.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/slider_custom_widget.dart';
import 'package:themoviedex/presentation/screen2/widgets/backdrop.dart';
import 'package:themoviedex/presentation/screen2/widgets/bottomsheet/flexible_bottom_sheet_route.dart';
import 'package:themoviedex/presentation/screen2/widgets/expandable_text.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:video_player/video_player.dart';

class DetailMoviePage extends StatefulWidget {
  int movieId;

  DetailMoviePage({Key key, @required this.movieId}) : super(key: key);

  @override
  _DetailMoviePageState createState() {
    return _DetailMoviePageState();
  }
}

class _DetailMoviePageState extends State<DetailMoviePage>
    with SingleTickerProviderStateMixin {
  DetailMoviePageProvider provider;
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);

  double backLayerHeight;
  double widthItemCast;
  double heightImageCast;
  double heightItemCast;

  //images
  double widthItemImage;
  double heightItemImage;

  //trailer
  VideoPlayerController vc;
  String coverurl;
  int playtime;
  int duration;


  @override
  void initState() {
    super.initState();
    provider = DetailMoviePageProvider(widget.movieId);
    widthItemCast = (Adapt.screenW() - Adapt.px(20)) / 4;
    heightImageCast = widthItemCast * 16 / 9;

    //images
    widthItemImage = (Adapt.screenW() - Adapt.px(20)) / 1.5;
    heightItemImage = widthItemImage * 9 / 16;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heightItemCast = heightImageCast + 3 * Adapt.px(10) + 2 * 16;
    backLayerHeight = Adapt.screenH() * 0.3 + 50;
    return SafeArea(
        child: Scaffold(
            body: ChangeNotifierProvider.value(
                value: provider,
                builder: (context, child) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      _pageNotifier.value = notification.extent;
                      print("Extent: ${notification.extent}");
                      setState(() {});
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                            color: Colors.black,
                            child: Consumer(
                              builder: (context,
                                  DetailMoviePageProvider provider, child) {
                                return buildBackChild();
                              },
                            )),
                        DraggableScrollableSheet(
                            initialChildSize: 0.70,
                            minChildSize: 0.70,
                            maxChildSize: 0.9,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Container(
                                padding: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.bottomNavigationBarBackgroundt,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Consumer(
                                        builder: (context,
                                            DetailMoviePageProvider provider,
                                            child) {
                                          return LayoutBuilder(
                                            builder: (context, constraints) {
                                              double maxHeight =
                                                  constraints.maxHeight;
                                              return ListView(
                                                controller: scrollController,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                children: [
                                                  buildImage(maxHeight),
                                                  Container(
                                                    child: Text(
                                                      "Cast",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  buildCast(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      "Overview",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: buildOverview()),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      "Images",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  buildImageList(),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    buildBottomWidget()
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                })));
  }

  Widget buildBackChild() {
    double opacity = (_pageNotifier.value - 0.7) / 0.2;
    if (opacity > 1.0) opacity = 1.0;
    if (opacity < 0.0) opacity = 0.0;
    print("${opacity}");
    return Container(
      height: backLayerHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildActionBar1(opacity),
          Opacity(
            opacity: 1 - opacity,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                provider.movieDetailModel.originalTitle ?? "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                R.img_ic_clock,
                width: 15,
                height: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${_covertDuration(provider.movieDetailModel?.runtime)}",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  getGenre(provider.movieDetailModel.genres),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                R.img_ic_favourite_active,
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                R.img_ic_add,
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                R.img_ic_share,
                width: 40,
                height: 40,
              ),
            ],
          )
        ],
      ),
    );
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

  String getGenre(List<Genre> list) {
    if (list == null) {
      return "";
    }
    String result = "";
    for (int i = 0; i < list.length; i++) {
      if (i != 0) {
        result += " | " + list[i].name;
      } else {
        result += list[i].name;
      }
    }
    return result;
  }

  Widget buildActionBar1(double opacity) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              NavigatorUtil.popSinglePage(context);
            },
            child: Image.asset(
              R.img_ic_back,
              width: 32,
              height: 23,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Opacity(
              opacity: opacity,
              child: Text(
                provider.movieDetailModel.originalTitle ?? "",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Opacity(
            opacity: 1 - opacity,
            child: Container(
              width: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.bottomNavigationBarBackgroundt),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    R.img_ic_score_star,
                    width: Adapt.px(60),
                    height: Adapt.px(60),
                  ),
                  Text(
                    provider.movieDetailModel.voteAverage?.toString() ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.amber),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomWidget() {
    double extent = (_pageNotifier.value - 0.7) / 0.2;
    if (extent > 1.0) extent = 1.0;
    if (extent < 0.0) extent = 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            if (!vc.value.initialized) {
              vc.initialize().then((_) {
                setState(() {
                  showplayer = false;
                });
                vc.play();
              });
            } else if (!vc.value.isPlaying) {
              setState(() {
                showplayer = false;
              });
              vc.play();
            } else {
              setState(() {
                showplayer = true;
              });
              vc.pause();
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppTheme.bg_rank_top_rate),
            width: Adapt.screenW() - 40,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "Watch trailer",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 10 * (1 - extent),
        ),
        Opacity(
          opacity: 1 - extent,
          child: Text(
            "Scroll to see more",
            style: TextStyle(color: AppTheme.color_text_scroll, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new RotatedBox(
          quarterTurns: 90 * extent.toInt(),
          child: Image.asset(
            R.img_ic_scroll_down,
            width: 20,
            height: 25,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildImage(double maxHeight) {
    double width = Adapt.screenW() * 0.7;
    double height = maxHeight - 20;
    return Container(
      margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: CachedNetworkImage(
          imageUrl: ImageUrl.getUrl(
              provider.movieDetailModel.posterPath, ImageSize.w300),
          fit: BoxFit.cover,
          width: width,
          height: height,
          placeholder: (context, url) => Image.asset(
            R.img_image_thumb,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            R.img_image_thumb,
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }

  Widget buildCast() {
    if (provider.movieDetailModel.credits != null &&
        provider.movieDetailModel.credits.cast != null) {
      List<CastData> listCast = provider.movieDetailModel.credits.cast;
      return Container(
        width: Adapt.screenW(),
        height: heightItemCast,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listCast.length,
          itemBuilder: (context, index) {
            var itemCast = listCast[index];
            return buildCastItem(itemCast);
          },
        ),
      );
    } else {
      return Container(
        width: Adapt.screenW(),
        height: heightItemCast,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return buildShimmerCastItem();
          },
        ),
      );
    }
  }

  Widget buildShimmerCastItem() {
    return Shimmer.fromColors(
        baseColor: AppTheme.bottomNavigationBarBackgroundt,
        highlightColor: AppTheme.item_bottomNavigation_selected,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: widthItemCast,
          height: heightItemCast,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widthItemCast,
                  height: heightImageCast,
                  decoration: BoxDecoration(
                      color: AppTheme.image_place_holder,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: widthItemCast,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.image_place_holder,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: widthItemCast,
                  height: 14,
                  decoration: BoxDecoration(
                      color: AppTheme.image_place_holder,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCastItem(CastData itemData) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 0),
      width: widthItemCast,
      height: heightItemCast,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: ImageUrl.getUrl(itemData.profilePath, ImageSize.w300),
                fit: BoxFit.cover,
                width: widthItemCast,
                height: heightImageCast,
                placeholder: (context, url) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemCast,
                  height: heightImageCast,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemCast,
                  height: heightImageCast,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              itemData.name ?? "",
              maxLines: 2,
              style: TextStyle(height: 1, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOverview() {
    return Text(
      provider.movieDetailModel.overview ?? "Empty",
      style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.normal),
    );
  }

  Widget buildImageList() {
    List<ImageData> listImage = [];
    if (provider.imageModel.posters != null) {
      listImage.addAll(provider.imageModel.posters);
    }
    if (provider.imageModel.backdrops != null) {
      listImage.addAll(provider.imageModel.backdrops);
    }
    if (listImage.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(left: 20),
        width: Adapt.screenW() - 20,
        height: heightItemImage,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listImage.length,
          itemBuilder: (context, index) {
            var itemCast = listImage[index];
            return buildImageItem(itemCast);
          },
        ),
      );
    } else {
      return Container(
        width: Adapt.screenW(),
        height: heightItemImage,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return buildShimmerImageItem();
          },
        ),
      );
    }
  }

  Widget buildShimmerImageItem() {
    return Shimmer.fromColors(
      baseColor: AppTheme.bottomNavigationBarBackgroundt,
      highlightColor: AppTheme.item_list_background,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        width: widthItemImage,
        height: heightItemImage,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            R.img_image_thumb,
            width: widthItemImage,
            height: heightItemImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildImageItem(ImageData itemData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: ImageUrl.getUrl(itemData.filePath, ImageSize.w300),
          fit: BoxFit.cover,
          width: widthItemImage,
          height: heightItemImage,
          placeholder: (context, url) => Image.asset(
            R.img_image_thumb,
            width: widthItemImage,
            height: heightItemImage,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            R.img_image_thumb,
            width: widthItemImage,
            height: heightItemImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
