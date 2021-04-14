import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/model/local/favorite_movie_hive.dart';
import 'package:themoviedex/data/model/local/playlist_hive.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/custom_pageview_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/RPSCustomPainter.dart';
import 'package:themoviedex/presentation/screen2/main/components/mymovie/my_movie_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';

class MyMoviePage extends StatefulWidget {
  MyMoviePage({Key key}) : super(key: key);

  @override
  _MyMoviePageState createState() {
    return _MyMoviePageState();
  }
}

class _MyMoviePageState extends State<MyMoviePage> {
  MyMovieProvider provider;
  double card_fav_width;
  double card_fav_height;
  double _imageWidth;
  double _partLeftWidth;
  double _partRightWidth;
  double postitionPartRight;
  PageController pageController = PageController(viewportFraction: 0.7);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyMovieProvider>(context, listen: false);
    card_fav_width = Adapt.screenW() - 40;
    card_fav_height = (card_fav_width * 0.2631578947368421).toDouble();
    _imageWidth = Adapt.px(180);
    _partLeftWidth = card_fav_width * 0.7894737;
    _partRightWidth = card_fav_width * (1 - 0.7894737).toDouble();
    postitionPartRight = _partLeftWidth;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.initData();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, MyMovieProvider provider, child) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "My Movies",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 20,),
              buildListMovieList(),
              SizedBox(height: 20,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),

                  Image.asset(R.img_ic_my_fav, width: 25,height: 25,),
                  SizedBox(width: 10,),
                  Container(
                    child: Text(
                      "Favourite",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              buildFavoriteList()


            ],
          );
        },
      ),
    );
  }

  Widget buildListMovieList() {
    final _cardWidth = Adapt.screenW() * 4/ 5- 10;
    final _cardHeight = (_cardWidth * 0.4).toDouble();
    return Container(
      height: _cardHeight,
      margin: EdgeInsets.only(left: 20),
      child: CustomPageView.builder(
      controller: pageController,
        viewportDirection: false,
        itemCount:
        provider.listPlayList.length,
        itemBuilder: (context, index) {
          return  buildItemListMovie(provider.listPlayList[index]);
        },
      ),
    );

  }

  Widget buildItemListMovie(PlayListHive itemData) {
    print("buildItem");
    final _cardWidth = Adapt.screenW() * 4/ 5- 10;
    final _cardHeight = (_cardWidth * 0.4).toDouble();
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

      },
      child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(10),
          width: _cardWidth,
          height: _cardHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.bottomNavigationBarBackgroundt),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: ImageUrl.getUrl(avatar, ImageSize.w300),
                  fit: BoxFit.cover,
                  height: _cardHeight - 20,
                  width: _cardHeight * 2/3,
                  placeholder: (context, url) =>
                      Image.asset(
                        R.img_image_thumb,
                        width: _cardHeight,
                        height: _cardHeight,
                        fit: BoxFit.cover,
                      ),
                  errorWidget: (context, url, error) =>
                      Image.asset(
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


  Widget buildFavoriteList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right:  20),
        child: ListView.builder(itemCount : provider.listFavorite.length, itemBuilder: (context, index) {
          return buildItemFavorite(provider.listFavorite[index]);
        },),
      ),
    );
  }

  Widget buildItemFavorite(FavoriteMovieHive listFavorite) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child:ClipRRect(
      borderRadius: BorderRadius.only(
    topRight: const Radius.circular(20),
    bottomRight: const Radius.circular(20),
    bottomLeft: const Radius.circular(30)),
        child:       Stack(
          children: [
            CustomPaint(
              size: Size(card_fav_width, card_fav_height),
              painter: RPSCustomPainter(),
            ),
            Positioned(
              child: Container(
                width: _partLeftWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: ImageUrl.getUrl(
                            listFavorite.posterPath, ImageSize.w300),
                        fit: BoxFit.cover,
                        height: card_fav_height,
                        width: _imageWidth,
                        placeholder: (context, url) => Image.asset(
                          R.img_image_thumb,
                          width: card_fav_height,
                          height: card_fav_height,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          R.img_image_thumb,
                          width: card_fav_height,
                          height: card_fav_height,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Adapt.px(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                listFavorite.title,
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
                                listFavorite.date,
                                maxLines: 2,
                                style:
                                TextStyle(color: Color(0xffc9cbcd)),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                left: postitionPartRight + _partRightWidth /2 - 20,
                top: card_fav_height / 2 -20,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(R.img_ic_trash, width: 20, height: 20,)
                  ),
                ))
          ],
        ),

      )
    );
  }
}