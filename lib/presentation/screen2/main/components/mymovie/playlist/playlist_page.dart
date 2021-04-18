import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/model/local/movie_item_list_hive.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/RPSCustomPainter.dart';
import 'package:themoviedex/presentation/screen2/main/components/mymovie/playlist/playlist_page_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class PlayListPage extends StatefulWidget {
  String playListId;
  PlayListPage({Key key, this.playListId}) : super(key: key);

  @override
  _PlayListPageState createState() {
    return _PlayListPageState();
  }
}

class _PlayListPageState extends State<PlayListPage> {
  PlayListPageProvider provider;
  double card_fav_width;
  double card_fav_height;
  double _imageWidth;
  double _partLeftWidth;
  double _partRightWidth;
  double postitionPartRight;
  @override
  void initState() {
    super.initState();
    provider = PlayListPageProvider(widget.playListId);
    card_fav_width = Adapt.screenW() - 40;
    card_fav_height = (card_fav_width * 0.2631578947368421).toDouble();
    _imageWidth = Adapt.px(180);
    _partLeftWidth = card_fav_width * 0.7894737;
    _partRightWidth = card_fav_width * (1 - 0.7894737).toDouble();
    postitionPartRight = _partLeftWidth;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppTheme.bottomNavigationBarBackground_light,
            body: Consumer(
              builder: (context, PlayListPageProvider provider, child) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            NavigatorUtil.popSinglePage(context);
                          },
                          child: Image.asset(
                            R.img_ic_back,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            provider.getTitle(),
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildAlbumList()
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildAlbumList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
          itemCount: provider.listItem.length,
          itemBuilder: (context, index) {
            return buildItemAlbum(provider.listItem[index], index);
          },
        ),
      ),
    );
  }

  Widget buildItemAlbum(MovieItemListHive itemData, int index) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.pushPageWithInterstitialAd(
            context,
            DetailMoviePage(
              movieId: itemData.id,
              movieType: itemData.isTvShow ? "tv" : "movie",
            ));
      },
      child: Container(
          margin: EdgeInsets.only(top: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
                bottomLeft: const Radius.circular(30)),
            child: Stack(
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
                                itemData.posterPath, ImageSize.w300),
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
                            margin:
                                EdgeInsets.symmetric(horizontal: Adapt.px(20)),
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
                                    itemData.date,
                                    maxLines: 2,
                                    style: TextStyle(color: Color(0xffc9cbcd)),
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
                    left: postitionPartRight + _partRightWidth / 2 - 20,
                    top: card_fav_height / 2 - 20,
                    child: GestureDetector(
                      onTap: () {
                        provider.deletePlayListItem(itemData.id, index);
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            R.img_ic_trash,
                            width: 20,
                            height: 20,
                          )),
                    ))
              ],
            ),
          )),
    );
  }
}
