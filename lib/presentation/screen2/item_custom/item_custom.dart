import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/presentation/screen2/item_custom/RPSCustomPainter.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/color_util.dart';
import 'item_custom_model.dart';

/// Created by dung.pham1 on 26/Mar/2021
///
/// Copyright ©2021 by dung.pham1. All rights reserved.
class ItemCustomWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateItemCustomWidget();
}

class _StateItemCustomWidget extends State<ItemCustomWidget> {
  @override
  Widget build(BuildContext context) {
    final _horizontalMargin = Adapt.px(10);
    final _cardWidth = Adapt.px(380);
    final _partLeftWidth = (Adapt.screenW() -
        _horizontalMargin * 2) * 0.7894737;



    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return ChangeNotifierProvider(
            create: (context) => ItemCustomModel(),
            child: Consumer<ItemCustomModel>(builder: (context, model, _) {
              return Container(
                margin: EdgeInsets.all(_horizontalMargin),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(30)),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(_cardWidth, (_cardWidth * 0.2631578947368421).toDouble()),
                        //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter(),
                      ),
                      Positioned(
                        left: 0,
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
                                  imageUrl:
                                      "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/6kbAMLteGO8yyewYau6bJ683sw7.jpg",
                                  fit: BoxFit.contain,
                                  height: _cardWidth * 0.2631578947368421,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                   fit: FlexFit.loose,
                                    child: Text(
                                      "Titledsadasdasdasdasdasdasdsadasdasdasdsdasdsadsad",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      "Descriptiondasdasdasdsadasddasdasdasdasdasdasda",
                                      style: TextStyle(color: HexColor("B0B5B9")),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
