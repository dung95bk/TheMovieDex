import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/detail_celeb_page.dart';
import 'package:themoviedex/presentation/screen2/main/components/celeb/celeb_page_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class CelebPage extends StatefulWidget {
  CelebPage({Key key}) : super(key: key);

  @override
  _CelebPageState createState() {
    return _CelebPageState();
  }
}

class _CelebPageState extends State<CelebPage> {
  double widthItemGrid;
  double heightItemGrid;
  bool isGrid = false;
  CelebPageProvider provider;
  double itemMargin;

  @override
  void initState() {
    super.initState();
    provider = CelebPageProvider();
    provider.initData();
    itemMargin = Adapt.px(10);
    double screenWidth = Adapt.screenW();
    double marginGrid = Adapt.px(10);
    widthItemGrid = (screenWidth - marginGrid * 2) * 2 / 5;
    heightItemGrid = widthItemGrid * 3 / 2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: SafeArea(
        child: Scaffold(
          extendBody: false,
          backgroundColor: AppTheme.bottomNavigationBarBackground_light,
          body: Column(
            children: [buildActionBar(), Expanded(child: buildGridView())],
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return Consumer(builder: (context, CelebPageProvider provider, child) {
      final orientation = MediaQuery.of(context).orientation;
      return Stack(
        children: [
          GridView.builder(
            controller: provider.scrollController,
            itemCount: provider.listPeople.length == 0
                ? 20
                : provider.listPeople.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 9 / 16,
                crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (provider.listPeople.length == 0) {
                return buildShimmerGridItem();
              } else {
                SearchResult itemData = provider.listPeople[index];
                print("Hero${index}:${itemData.id}");

                return buildItemGridView(itemData, index);
              }
            },
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.bottomNavigationBarBackground_light.withOpacity(0),
                      AppTheme.bottomNavigationBarBackground_light.withOpacity(0.1),
                      AppTheme.bottomNavigationBarBackground_light.withOpacity(0.9),
                    ],
                    stops: [
                      0,
                      0.95,
                      0.98
                    ]),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget buildItemGridView(SearchResult itemData, int index) {
    return Hero(
      tag: index,

      child: Material(
        color: AppTheme.bottomNavigationBarBackground_light,
        child: InkWell(
          onTap: () {
            NavigatorUtil.pushPage(context, DetailCelebPage(celebId: itemData.id,urlAvatar: itemData.profilePath, animationTag: index));

          },
          child: Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: ImageUrl.getUrl(itemData.profilePath, ImageSize.w300),
                    fit: BoxFit.cover,
                    width: widthItemGrid,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      width: widthItemGrid,
                      height: heightItemGrid,
                      color: AppTheme.image_place_holder,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: heightItemGrid,
                      height: heightItemGrid,
                      color: AppTheme.image_place_holder,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerGridItem() {
    return Shimmer.fromColors(
      baseColor: AppTheme.bottomNavigationBarBackgroundt,
      highlightColor: AppTheme.item_list_background,
      child: Container(
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: widthItemGrid,
                  height: heightItemGrid,
                  color: AppTheme.item_list_background,
                )),
          ],
        ),
      ),
    );
  }

  Widget buildActionBar() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      child: Text(
        "Popular People",
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
