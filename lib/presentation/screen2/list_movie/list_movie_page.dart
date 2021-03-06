import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/data/remote/models/video_list.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/list_movie/list_movie_page_provider.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/item_tv_show_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/shimmer/shimmer_tv_show.dart';
import 'package:themoviedex/presentation/screen2/testads/ads_manager.dart';
import 'package:themoviedex/presentation/screen2/testads/publisher_banner_ads.dart';
import 'package:themoviedex/presentation/screen2/widgets/tabbar_list_movie_widget.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/const.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class ListMoviePage extends StatefulWidget {
  String title;
  int typeList = TYPE_LIST_MOVIE_TOP_RATED;

  ListMoviePage({Key key, this.title, this.typeList}) : super(key: key);

  @override
  _ListMoviePageState createState() {
    return _ListMoviePageState();
  }
}

class _ListMoviePageState extends State<ListMoviePage> {
  ListMoviePageProvider provider;
  double itemMargin;
  double widthItem;
  double widthItemGrid;
  double heightItemGrid;
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    provider = ListMoviePageProvider(widget.typeList);
    provider.initData();
    itemMargin = Adapt.px(10);
    double screenWidth = Adapt.screenW();
    double marginLeft = Adapt.px(10);
    double marginTop = Adapt.px(30);
    widthItem = screenWidth - marginLeft * 2 - itemMargin * 4;
    double marginGrid = Adapt.px(10);
    widthItemGrid = (screenWidth - marginGrid * 2) * 2 / 5;
    heightItemGrid = widthItemGrid * 3 / 2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            children: [
              buildActionBar(),
              isGrid
                  ? Expanded(child: buildGridView())
                  : Expanded(child: buildListView())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionBar() {
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
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              "${widget.title}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )),
          buildSwitcher()
        ],
      ),
    );
  }

  Widget buildSwitcher() {
    return TabbarListMovieWidget(
      isGrid: (isGrid) {
        this.isGrid = isGrid;
        setState(() {});
      },
    );
  }

  Widget buildListView() {
    return Consumer(builder: (context, ListMoviePageProvider provider, child) {
      return ListView.builder(
        controller: provider.scrollController,
        scrollDirection: Axis.vertical,
        itemCount: provider.listTvShow.length == 0
            ? 20
            : (AdsManager.instance.isCanShowNativeAds()
                ? (provider.listTvShow.length +
                    (provider.listTvShow.length / 20) +
                    1)
                : provider.listTvShow.length),
        itemBuilder: (context, index) {
          if (provider.listTvShow.length == 0) {
            return ShimmerItem();
          } else {
            Widget adWidget;
            if (index % 20 == 0) {
              adWidget = PublisherBannerAdWidget(AdSize.largeBanner);
            }
            if (adWidget != null) return Center(child: adWidget);
            VideoListResult itemData = provider.listTvShow[index];
            return createItemListTvShow(itemData);
          }
        },
      );
    });
  }

  Widget buildGridView() {
    return Consumer(builder: (context, ListMoviePageProvider provider, child) {
      final orientation = MediaQuery.of(context).orientation;
      return GridView.builder(
        controller: provider.scrollController,
        itemCount:
            provider.listTvShow.length == 0 ? 20 : provider.listTvShow.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 9 / 16,
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (provider.listTvShow.length == 0) {
            return buildShimmerGridItem();
          } else {
            VideoListResult itemData = provider.listTvShow[index];
            return buildItemGridView(itemData);
          }
        },
      );
    });
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

  Widget buildItemGridView(VideoListResult itemData) {
    return GestureDetector(
      onTap: () async {},
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
                imageUrl: ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
                fit: BoxFit.cover,
                width: widthItemGrid,
                height: double.infinity,
                placeholder: (context, url) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemGrid,
                  height: heightItemGrid,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemGrid,
                  height: heightItemGrid,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createItemListTvShow(VideoListResult itemData) {
    bool isMovie = widget.typeList < TYPE_LIST_TVSHOW_POPULAR;
    return ItemTVShowWidget(
        key: ValueKey(itemData.id), itemData: itemData, isTvShow: !isMovie);
  }
}
