import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/data/remote/models/models.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/item_tv_show/item_tv_show_widget.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/shimmer/shimmer_tv_show.dart';
import 'package:themoviedex/presentation/screen2/main/components/home/tvshow/tv_show_page_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class TvShowPage extends StatefulWidget {
  TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() {
    return _TvShowPageState();
  }
}

class _TvShowPageState extends State<TvShowPage> {
  double itemMargin;
  double widthItem;

  @override
  void initState() {
    super.initState();
    Provider.of<TvShowPageProvider>(context, listen: false).initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    itemMargin = Adapt.px(10);
    double screenWidth = Adapt.screenW();
    double marginLeft = Adapt.px(10);
    double marginTop = Adapt.px(30);
    widthItem = screenWidth - marginLeft * 2 - itemMargin * 4;
    return Column(
      children: [
     
        Expanded(child: _createListTvShow())
      ],
    );
  }

  Widget _createListTvShow() {
    return Consumer(builder: (context, TvShowPageProvider provider, child) {

        return ListView.builder(
          controller: provider.scrollController,
          scrollDirection: Axis.vertical,
          itemCount: provider.listTvShow.length == 0 ? 21 : provider.listTvShow.length  + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              double heightGridView = (widthItem + itemMargin * 2) * 2;
              double marginLeft = Adapt.px(10);
              double marginTop = Adapt.px(30);
              return Container(
                  height: Adapt.px(heightGridView),
                  margin: EdgeInsets.only(
                      top: marginTop, left: marginLeft, right: marginLeft),
                  child: _createGridCategory());
            } else {
              if(provider.listTvShow.length == 0) {
                return ShimmerItem();
              } else {
                VideoListResult itemData = provider.listTvShow[index - 1];
                return createItemListTvShow(itemData);
              }
            }
          },
        );

    });
  }

  Widget _createGridCategory() {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 1, crossAxisCount: 2),
      children: [
        createItemGridCategory(R.img_ic_tv_popular, "Popular"),
        createItemGridCategory(R.img_ic_tv_ontv, "On TV"),
        createItemGridCategory(R.img_ic_tv_toprate, "Top Rated"),
        createItemGridCategory(R.img_ic_tv_airing, "Airing Today"),
      ],
    );
  }

  Widget createItemListTvShow(VideoListResult itemData) {
    return ItemTVShowWidget(  key: ValueKey(itemData.id), itemData: itemData,);
  }

  Widget createItemGridCategory(String icon, String label) {
    return GestureDetector(
      onTap: () {
        print("TAP");
        Provider.of<TvShowPageProvider>(context, listen: false).initData();
      },
      child: Container(
        margin: EdgeInsets.all(itemMargin),
        height: widthItem,
        width: widthItem,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppTheme.bottomNavigationBarBackgroundt),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 50,
              height: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              label,
              style: TextStyle(
                  color: AppTheme.item_list_background,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
