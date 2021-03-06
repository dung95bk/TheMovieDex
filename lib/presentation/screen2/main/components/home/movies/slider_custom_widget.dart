import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_movies/detail_movies_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/custom_pageview_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/slider_custom_widget_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class SliderCustomWidget extends StatefulWidget {
  SliderCustomWidgetProvider provider;
  PageStorageKey sliderKey= PageStorageKey("P");
  ValueChanged<int> onItemClick;
  SliderCustomWidget({Key key, this.provider, this.onItemClick}) : super(key: key);

  @override
  _SliderCustomWidgetState createState() {
    return _SliderCustomWidgetState();
  }
}

class _SliderCustomWidgetState extends State<SliderCustomWidget> {
  //slider
  double itemSliderWidth;
  double itemSliderHeight;
  double heightText;
  PageController pageController;
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);
  double marginList;
  SliderCustomWidgetProvider provider;

  void _listener() {
    print("_listener -${pageController.page}");

    _pageNotifier.value = pageController.page;
    setState(() {});
  }

  @override
  void initState() {
    print("initStateslider");
    pageController = widget.provider.pageController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.addListener(_listener);
    });

    super.initState();
    itemSliderWidth = (Adapt.screenW()) * 2 / 3;
    provider = widget.provider;
  }

  @override
  void dispose() {
    pageController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = 'TV Show';
    final style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);
    heightText = textPainter.height;
    itemSliderHeight = itemSliderWidth + 20 + textPainter.height * 3;
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer(
        builder: (context, SliderCustomWidgetProvider provider, child) {
          return Container(
            height: itemSliderHeight,
            child: Stack(
              children: [
                buildImageBackground(),
                buildWhiteShadowBackground(),
                buildPager()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPager() {

    return CustomPageView.builder(

      viewportDirection: false,
      itemCount:
          provider.listMovies.length == 0 ? 3 : provider.listMovies.length,
      controller: pageController,
      itemBuilder: (context, index) {
        final lerp = lerpDouble(1, 0.8, (index - _pageNotifier.value).abs());
        // Tr??? v??? gi?? tr??? n???m gi???a 0.0 v?? 0.5 khi index ch???y t??? currentIndex to newIndex (vd: 2->3)
        double opacity =
            lerpDouble(0.0, 0.5, (index - _pageNotifier.value).abs());
        if (opacity > 1.0) opacity = 1.0;
        if (opacity < 0.0) opacity = 0.0;
        if( provider.listMovies.length != 0 ) {
          VideoListResult itemData = provider.listMovies[index];
          return buildItemSlider(lerp, opacity, itemData);
        } else {
          return buildShimmerSlider(lerp, opacity, null);
        }
      },
    );
  }

  Widget buildShimmerSlider(double lerpScale, double opacity, VideoListResult itemData) {
    return Shimmer.fromColors(
      baseColor: AppTheme.bottomNavigationBarBackgroundt,
      highlightColor: AppTheme.item_list_background,
      child: Transform.scale(
        scale: lerpScale,
        //?????y item xu???ng 50px
        child: Opacity(
          //ph??? m??? 50%
          opacity: (1 - opacity),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: itemSliderWidth,
                    width: itemSliderWidth,
                    color: AppTheme.item_list_background,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: itemSliderWidth,
                  height: heightText,
                  color: AppTheme.item_list_background,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: itemSliderWidth,
                  height: heightText,
                  color: AppTheme.item_list_background,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemSlider(double lerpScale, double opacity, VideoListResult itemData) {
    return GestureDetector(
      onTap: () {
        widget.onItemClick(itemData.id);
      },
      child: Transform.scale(
        scale: lerpScale,
        //?????y item xu???ng 50px
        child: Opacity(
          //ph??? m??? 50%
          opacity: (1 - opacity),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl:
                    ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
                    fit: BoxFit.cover,
                    height: itemSliderWidth,
                    width: itemSliderWidth,
                    placeholder: (context, url) => Image.asset(R.img_image_thumb,
                      width: itemSliderWidth,
                      height: itemSliderWidth,
                      fit: BoxFit.cover,

                    ),
                    errorWidget: (context, url, error) => Image.asset(R.img_image_thumb,
                      width: itemSliderWidth,
                      height: itemSliderWidth,
                      fit: BoxFit.cover,

                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: itemSliderWidth,
                  child: Text(
                    itemData.title == null ? "" : itemData.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: itemSliderWidth,
                  child: Text(
                    itemData.releaseDate,
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xffc9cbcd),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageBackground() {
    return Positioned.fill(
      child: ValueListenableBuilder<double>(
        valueListenable: _pageNotifier,
        builder: (context, value, child) {
          return Container();
        },
      ),
    );
  }

  Widget buildWhiteShadowBackground() {
    return Positioned(
      left: 0,
      top: 0,
      height: itemSliderHeight / 3,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white60,
            Colors.white24,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double percentage;
  final String title;
  final int index;
  final int listLenght;

  MyClipper({this.percentage = 0.0, this.title, this.index, this.listLenght});

  @override
  Rect getClip(Size size) {
    int currentIndex = listLenght - 1 - index;
    final realPercent = (currentIndex - percentage).abs();
    if (currentIndex == percentage.truncate()) {
      return Rect.fromLTWH(
          0.0, 0.0, size.width * (1 - realPercent), size.height);
    }
    if (percentage.truncate() > currentIndex) {
      return Rect.fromLTWH(0.0, 0.0, 0.0, size.height);
    }
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
