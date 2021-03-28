
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/RPSCustomPainter.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppTheme.bottomNavigationBarBackgroundt,
        highlightColor: AppTheme.item_list_background, child: Item(color: Colors.grey.shade900));
  }
}

class Item extends StatelessWidget {
  final Color color;

  const Item({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _horizontalMargin = Adapt.px(10);
    final _cardWidth = Adapt.screenW() - _horizontalMargin * 2;
    final _cardHeight = (_cardWidth * 0.2631578947368421).toDouble();
    final _imageWidth = Adapt.px(180);
    final _partLeftWidth = _cardWidth * 0.7894737;
    final _partRightWidth = _cardWidth * (1 - 0.7894737).toDouble();
    final postitionPartRight = _partLeftWidth;
    return  Builder(builder: (BuildContext context) {
      return  Container(
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
                        child: Container(
                          color: color,
                          height: _cardHeight,
                          width: _imageWidth,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Adapt.px(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment:  MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  height: 20,
                                  color: color,
                                ),
                              ),
                              SizedBox(
                                height: Adapt.px(10),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  height: 20,
                                  color: color,
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
                        Container(
                          height: 20,
                          width: 20,
                          color: color,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }

}