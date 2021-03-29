import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/movies/movies_page_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({Key key}) : super(key: key);

  @override
  _MoviesPageState createState() {
    return _MoviesPageState();
  }
}

class _MoviesPageState extends State<MoviesPage> {
  double itemSliderWidth;
  double marginList;
  double itemRowCategory;
  double itemTopRatedWidth;
  double itemTopRatedImageWidth;
  double itemTopRatedHeight;

  @override
  void initState() {
    super.initState();
    marginList = Adapt.px(10);
    itemSliderWidth = (Adapt.screenW() - marginList * 2) * 2 / 3;
    itemRowCategory = (Adapt.screenW() - marginList * 2) / 2;
    itemTopRatedWidth = Adapt.screenW() - marginList * 2;
    itemTopRatedImageWidth = itemTopRatedWidth / 5;
    itemTopRatedHeight = itemTopRatedWidth / 3;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      child: buildRowCategory(),
      builder: (context, MoviesPageProvider provider, child) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: provider.listTopRatedMovies.length == 0
              ? 10
              : provider.listTopRatedMovies.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return buildSlider(provider);
            } else if (index == 1) {
              return buildRowCategory();
            } else if (provider.listTopRatedMovies.length == 0) {
              return buildShimmerItemTopRated();
            } else {
              return buildItemTopRated(provider.listTopRatedMovies[index - 2], index -2);
            }
          },
        );
      },
    );
  }

  Widget buildShimmerItemSlider() {}

  Widget buildShimmerItemTopRated() {}

  Widget buildItemTopRated(VideoListResult itemData, int index) {
    return Container(
        margin: EdgeInsets.all(marginList),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: itemTopRatedHeight,
            height: itemTopRatedHeight,
            decoration: BoxDecoration(
                color: AppTheme.bottomNavigationBarBackgroundt,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                CachedNetworkImage(
                    imageUrl:
                        ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
                    fit: BoxFit.cover,
                    height: itemTopRatedHeight,
                    width: itemTopRatedImageWidth,
                    placeholder: (context, url) => Container(
                          height: itemTopRatedHeight,
                          width: itemTopRatedImageWidth,
                          color: AppTheme.image_place_holder,
                        ),
                    errorWidget: (context, url, error) => Container(
                          height: itemTopRatedHeight,
                          width: itemTopRatedImageWidth,
                          color: AppTheme.image_place_holder,
                        )),

                Column(
                  children: [
                    Text(

                    ),
                    Text(

                    )
                  ],
                ),
                if(index == 0) {
                  return Image.asset(name)
                }
              ],
            ),
          ),
        ));
  }

  Widget buildRowCategory() {
    return Row(
      children: [
        Image.asset(
          R.img_ic_nowplay,
          width: itemRowCategory,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          R.img_ic_popularmovie,
          width: itemRowCategory,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget buildSlider(MoviesPageProvider provider) {
    return CarouselSlider.builder(
      itemCount:
          provider.listMovies.length == 0 ? 2 : provider.listMovies.length,
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        if (provider.listMovies.length == 0) {
          return buildShimmerItemSlider();
        } else {
          return buildItemSlider(provider.listMovies[index]);
        }
      },
    );
  }

  Widget buildItemSlider(VideoListResult itemData) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
          fit: BoxFit.cover,
          height: itemSliderWidth,
          width: itemSliderWidth,
          placeholder: (context, url) => Container(
            width: itemSliderWidth,
            height: itemSliderWidth,
            color: AppTheme.image_place_holder,
          ),
          errorWidget: (context, url, error) => Container(
            width: itemSliderWidth,
            height: itemSliderWidth,
            color: AppTheme.image_place_holder,
          ),
        ),
        Text(
          "TSDASDDASDASDASDASDASDASDSDSADAS",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "TSDASDDASDASDASDASDASDASDSDSADAS",
          style: TextStyle(color: Color(0xffc9cbcd)),
        )
      ],
    );
  }
}
