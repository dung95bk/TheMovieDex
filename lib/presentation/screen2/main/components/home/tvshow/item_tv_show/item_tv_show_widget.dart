import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

import 'RPSCustomPainter.dart';
import 'item_custom_model.dart';

/// Created by dung.pham1 on 26/Mar/2021
///
/// Copyright ©2021 by dung.pham1. All rights reserved.
class ItemTVShowWidget extends StatefulWidget {
  Object itemData;
  bool isTvShow = true;

  @override
  State<StatefulWidget> createState() => _StateItemCustomWidget();

  ItemTVShowWidget({Key key, this.itemData, this.isTvShow = true})
      : super(key: key);
}

class _StateItemCustomWidget extends State<ItemTVShowWidget> {
  @override
  Widget build(BuildContext context) {
    final _horizontalMargin = Adapt.px(10);
    final _cardWidth = Adapt.screenW() - _horizontalMargin * 2;
    final _cardHeight = (_cardWidth * 0.2631578947368421).toDouble();
    final _imageWidth = Adapt.px(180);
    final _partLeftWidth = _cardWidth * 0.7894737;
    final _partRightWidth = _cardWidth * (1 - 0.7894737).toDouble();
    final postitionPartRight = _partLeftWidth;
    dynamic itemData;
    if (widget.itemData is VideoListResult) {
      itemData = widget.itemData;
    } else {
      itemData = widget.itemData;
    }
    print("Data Item: ${itemData}");
    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          print("asdad");
          NavigatorUtil.pushPageWithInterstitialAd(
              context,
              DetailMoviePage(
                movieId: itemData.id,
                movieType: widget.isTvShow ? "tv" : "movie",
              ));
        },
        child: ChangeNotifierProvider(
          create: (context) => ItemCustomModel(),
          child: Consumer<ItemCustomModel>(builder: (context, model, _) {
            return Container(
              margin: EdgeInsets.all(_horizontalMargin),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                    bottomLeft: const Radius.circular(30)),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(_cardWidth, _cardHeight),
                      //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
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
                                height: _cardHeight,
                                width: _imageWidth,
                                placeholder: (context, url) => Image.asset(
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
                                        widget.isTvShow
                                            ? (itemData.name ?? "null")
                                            : (itemData.originalTitle ??
                                                "null"),
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
                                        widget.isTvShow
                                            ? (itemData.firstAirDate ?? "null")
                                            : (itemData.releaseDate ?? "null"),
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
                        left: postitionPartRight,
                        child: Container(
                          width: _partRightWidth,
                          height: _cardHeight,
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
                                itemData.voteAverage?.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
