import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/model/local/playlist_hive.dart';
import 'package:themoviedex/data/remote/models/credits_model.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/image_model.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/detail_celeb_page.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/adapter_movie_model.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page_provider.dart';
import 'package:themoviedex/presentation/screen2/widgets/share_card.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMoviePage extends StatefulWidget {
  int movieId;
  String movieType;

  DetailMoviePage({Key key, @required this.movieId, @required this.movieType})
      : super(key: key);

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

  String coverurl;
  int playtime;
  int duration;

  // screen
  double _padding;
  double _width;
  double _height;
  bool isShowClose = false;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    provider = DetailMoviePageProvider(widget.movieId, widget.movieType);
    widthItemCast = (Adapt.screenW() - Adapt.px(20)) / 4;
    heightImageCast = widthItemCast * 16 / 9;

    //images
    widthItemImage = (Adapt.screenW() - Adapt.px(20)) / 1.5;
    heightItemImage = widthItemImage * 9 / 16;
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300));

    offset = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset(0.0, 0.0),
    ).animate(controller);
  }

  @override
  void dispose() {
    if (provider.youtubePlayerController != null) {
      provider.youtubePlayerController.dispose();
    }
    super.dispose();
  }

  Future<bool> _checkForLandscape(BuildContext ctx) async {
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    if (provider.isShowTrailerLayout) {
      controller.reverse();
      isShowClose = false;
      provider.hideTrailerLayout();
      return false;
    } else {
      return true;
    }
  }

  void showAddMovieList() {
    showModalBottomSheet(
        context: context,
        elevation: 20,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).viewInsets.bottom + 220,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: Adapt.screenW() / 5,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.bottomNavigationBarBackgroundt,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showAddMovieList();
                          },
                          child: Text(
                            "Create new playlist",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: Color(0xFF666F7A), width: 1)),
                          child: TextField(
                            controller: provider.editingController,
                            decoration: InputDecoration(
                                hintText: "Name playlist…",
                                hintStyle: TextStyle(
                                    color: Color(0xFF666F7A),
                                    decoration: TextDecoration.none,
                                    fontSize: 16),
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                focusColor: Colors.white,
                                border: InputBorder.none),
                            style: TextStyle(color: Colors.white),
                            onSubmitted: (newValue) {},
                            autofocus: false,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (provider.editingController.text.isEmpty) {
                                showToast("Fill the name");
                              } else if (!provider.isNameValidated()) {
                                showToast("Name existed");
                              } else {
                                if (provider.createPlayList()) {
                                  Navigator.pop(context);
                                  showMovieList();
                                }
                              }
                            },
                            child: Opacity(
                              opacity: 1,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 40, right: 40),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: AppTheme.bg_rank_top_rate),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ]));
        });
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showMovieList() {
    if (!provider.isHasImageData) {
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: Adapt.screenH() / 2,
              child: Column(children: [
                Container(
                  width: Adapt.screenW() / 5,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: Adapt.screenH() / 2 - 20,
                  decoration: BoxDecoration(
                    color: AppTheme.bottomNavigationBarBackgroundt,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select playlists",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                NavigatorUtil.popSinglePage(context);
                                showAddMovieList();
                              },
                              child: Image.asset(
                                R.img_ic_add_new,
                                width: 40,
                                height: 40,
                              )),
                        ],
                      ),
                      Expanded(child: buildListMovie())
                    ],
                  ),
                ),
              ]));
        });
  }

  Widget buildListMovie() {
    return ListView.builder(
      itemCount: provider.listPlayList.length,
      itemBuilder: (context, index) {
        return buildItemListMovie(provider.listPlayList[index]);
      },
    );
  }

  Widget buildItemListMovie(PlayListHive itemData) {
    print("buildItem");
    final _cardWidth = Adapt.screenW() - 20 * 2;
    final _cardHeight = (_cardWidth * 0.2631578947368421).toDouble();
    int numMovie = 0;
    if (itemData.listItem != null) {
      numMovie = itemData.listItem.length;
    }
    String avatar = "";
    if (numMovie > 0) {
      avatar = itemData.listItem[0].posterPath;
    }
    return GestureDetector(
      onTap: () {
        if (provider.saveMovie(itemData.id)) {
          NavigatorUtil.popSinglePage(context);
          showToast("Success");
        }
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          width: _cardWidth,
          height: _cardHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.bottomNavigationBarBackground_light),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: ImageUrl.getUrl(avatar, ImageSize.w300),
                  fit: BoxFit.cover,
                  height: _cardHeight - 20,
                  width: _cardWidth / 5,
                  placeholder: (context, url) => Image.asset(
                    R.img_image_thumb,
                    width: _cardHeight,
                    height: _cardHeight,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    R.img_image_thumb,
                    width: _cardHeight,
                    height: _cardHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          itemData.title,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Adapt.px(10),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "${numMovie} movies",
                          maxLines: 2,
                          style: TextStyle(color: Color(0xffc9cbcd)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    heightItemCast = heightImageCast + 3 * Adapt.px(10) + 2 * 16;
    backLayerHeight = Adapt.screenH() * 0.3 + 50;
    Size viewsSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => _checkForLandscape(context),
      child: SafeArea(
          child: Scaffold(
              body: ChangeNotifierProvider.value(
                  value: provider,
                  builder: (context, child) {
                    return NotificationListener<
                        DraggableScrollableNotification>(
                      onNotification: (notification) {
                        _pageNotifier.value = notification.extent;
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
                                                                FontWeight
                                                                    .bold),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
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
                                                                FontWeight
                                                                    .bold),
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
                          GestureDetector(
                            onTap: () {
                              print("showclose");
                              if (isShowClose) {
                                controller.reverse();
                              } else {
                                controller.forward();
                              }
                              isShowClose = !isShowClose;
                            },
                            child: Consumer(
                              builder: (context,
                                  DetailMoviePageProvider provider, child) {
                                return provider.isShowTrailerLayout
                                    ? Container(
                                        height: viewsSize.height,
                                        width: viewsSize.width,
                                        color: Colors.black,
                                        child: Stack(
                                          children: [
                                            SlideTransition(
                                              position: offset,
                                              child: AnimatedContainer(
                                                duration: Duration(seconds: 3),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _checkForLandscape(
                                                          context);
                                                      controller.reverse();
                                                      isShowClose = false;
                                                      provider
                                                          .hideTrailerLayout();
                                                    },
                                                    child: Image.asset(
                                                      R.img_ic_close_video,
                                                      width: 60,
                                                      height: 60,
                                                    )),
                                              ),
                                            ),
                                            provider.isHasVideoData
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    child: _VideoPlayer(
                                                      controller: provider
                                                          .youtubePlayerController,
                                                      play: true,
                                                      onEnd: () => provider
                                                          .startPlayVideo(
                                                              false),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      )
                                    : SizedBox();
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }))),
    );
  }

  void _share(BuildContext context) {
    if (!provider.isHasImageData) return;
    AdapterMovieModel model = provider.adapterMovieModel;
    if (model == null) return;
    showDialog(
        context: context,
        builder: (ctx) {
          var width = (Adapt.screenW() - Adapt.px(60)).floorToDouble();
          var height = ((width - Adapt.px(40)) / 2).floorToDouble();
          return ShareCard(
            backgroundImage:
                ImageUrl.getUrl(model.backdropPath, ImageSize.w300),
            qrValue:
                'https://www.themoviedb.org/movie/${model.id}?language=${ui.window.locale.languageCode}',
            headerHeight: height,
            header: Column(children: <Widget>[
              SizedBox(
                height: Adapt.px(20),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: Adapt.px(20),
                  ),
                  Container(
                    width: Adapt.px(120),
                    height: Adapt.px(120),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white, width: Adapt.px(5)),
                        borderRadius: BorderRadius.circular(Adapt.px(60)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(ImageUrl.getUrl(
                                model.posterPath, ImageSize.w300)))),
                  ),
                  SizedBox(
                    width: Adapt.px(20),
                  ),
                  Container(
                    width: width - Adapt.px(310),
                    child: Text(model.title,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Adapt.px(40),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: Adapt.px(20),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                  width: width - Adapt.px(40),
                  height: height - Adapt.px(160),
                  child: Text(model.overview,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Adapt.px(24),
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(Adapt.px(1), Adapt.px(1)),
                                blurRadius: 3)
                          ])),
                ),
              )
            ]),
          );
        });
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
                provider.adapterMovieModel.title ?? "",
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
                "${provider.adapterMovieModel.duration ?? ""}",
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
                  getGenre(provider.adapterMovieModel.genres),
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
              GestureDetector(
                onTap: () {
                  provider.favorite();
                },
                child: Image.asset(
                  provider.isFavorite
                      ? R.img_ic_favourite_active
                      : R.img_ic_favourite,
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  showMovieList();
                },
                child: Image.asset(
                  R.img_ic_add,
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  _share(context);
                },
                child: Image.asset(
                  R.img_ic_share,
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          )
        ],
      ),
    );
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
                provider.adapterMovieModel.title ?? "",
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

  // void playButtonClicked() {
  //   if(!provider.isHasVideoData) return;
  //   if (!provider.videoPlayerController.value.isInitialized) {
  //     provider.videoPlayerController.initialize().then((_) {
  //       setState(() {
  //         showplayer = false;
  //       });
  //       provider.videoPlayerController.play();
  //     });
  //   } else if (!provider.videoPlayerController.value.isPlaying) {
  //     setState(() {
  //       showplayer = false;
  //     });
  //     provider.videoPlayerController.play();
  //   } else {
  //     setState(() {
  //       showplayer = true;
  //     });
  //     provider.videoPlayerController.pause();
  //   }
  // }

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
            provider.showTrailerLayout();
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
              provider.adapterMovieModel.posterPath, ImageSize.w300),
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
    if (provider.adapterMovieModel.credits != null &&
        provider.adapterMovieModel.credits.cast != null) {
      List<CastData> listCast = provider.adapterMovieModel.credits.cast;
      return Container(
        width: Adapt.screenW(),
        height: heightItemCast,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listCast.length,
          itemBuilder: (context, index) {
            var itemCast = listCast[index];
            return buildCastItem(itemCast, index);
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

  Widget buildCastItem(CastData itemData, int index) {
    return Hero(
        tag: index,
        child: Material(
            color: AppTheme.bottomNavigationBarBackground_light,
            child: InkWell(
              onTap: () {
                NavigatorUtil.pushPageWithInterstitialAd(
                    context,
                    DetailCelebPage(
                        celebId: itemData.id,
                        urlAvatar: itemData.profilePath,
                        animationTag: index));
              },
              child: Container(
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
                          imageUrl: ImageUrl.getUrl(
                              itemData.profilePath, ImageSize.w300),
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
                        style: TextStyle(
                            height: 1, fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget buildOverview() {
    return Text(
      provider.adapterMovieModel.overview ?? "Empty",
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

class _VideoPlayer extends StatelessWidget {
  final YoutubePlayerController controller;
  final bool play;
  final Function onEnd;

  const _VideoPlayer({this.controller, this.play, this.onEnd});

  @override
  Widget build(BuildContext context) {
    Size viewsSize = MediaQuery.of(context).size;
    final _width = viewsSize.width;
    double _height = _width * 9 / 16;
    if (viewsSize.width > viewsSize.height) {
      _height = viewsSize.height;
    }
    return play
        ? GestureDetector(
            onTap: () {
              print("onTap");
            },
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: controller,
                onEnded: (d) => controller.play(),
                progressColors: ProgressBarColors(
                  playedColor: const Color(0xFFFFFFFF),
                  handleColor: const Color(0xFFFFFFFF),
                  bufferedColor: const Color(0xFFE0E0E0),
                ),
              ),
              builder: (context, widget) {
                return Container(
                  height: _height,
                  width: _width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Adapt.px(25)),
                    child: Stack(children: [
                      widget,
                      GestureDetector(
                          onTap: () {
                            print("onTapVideo");
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                          ))
                    ]),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }
}
