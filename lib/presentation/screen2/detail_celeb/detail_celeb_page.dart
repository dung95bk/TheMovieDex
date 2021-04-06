import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/combined_cast_data.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/acting_model.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/detail_celeb_page_provider.dart';
import 'package:themoviedex/presentation/screen2/widgets/expandable_text.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class DetailCelebPage extends StatefulWidget {
  int celebId;
  String urlAvatar;
  int animationTag;

  DetailCelebPage(
      {Key key,
      @required this.celebId,
      @required this.urlAvatar,
      @required this.animationTag})
      : super(key: key);

  @override
  _DetailCelebPageState createState() {
    return _DetailCelebPageState();
  }
}

class _DetailCelebPageState extends State<DetailCelebPage> {
  DetailCelebPageProvider provider;
  double margin;
  double avatarWidth;
  double avatarHeight;
  double widthItemKnowFor;
  double heightImageKnowFor;

  double heightItemKnowFor;

  @override
  void initState() {
    super.initState();
    provider = DetailCelebPageProvider(widget.celebId);
    margin = Adapt.px(20);
    avatarWidth = (Adapt.screenW() - margin * 2) / 4;
    avatarHeight = avatarWidth * 16 / 9;
    widthItemKnowFor = (Adapt.screenW() - margin) / 3;
    heightImageKnowFor = widthItemKnowFor * 16 / 9;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heightItemKnowFor = heightImageKnowFor + 3 * Adapt.px(10) + 2 * 16;

    return ChangeNotifierProvider.value(
      value: provider,
      builder: (context, child) {
        return Consumer(
          builder: (context, DetailCelebPageProvider provider, child) {
            List<Widget> listWidget = List<Widget>();
            listWidget.add(
              buildInfoItem(provider),
            );
            listWidget.add(
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  'Know for',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
            listWidget.add(buildKnowFor(provider));
            listWidget.add(
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  'Acting',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
            if (provider.listKnowForAll.isNotEmpty) {
              listWidget.addAll(provider.listActing
                  .map((e) => buildActingItem(e))
                  .toList());
            }
            return SafeArea(
              child: Scaffold(
                  backgroundColor: AppTheme.bottomNavigationBarBackground_light,
                  body: ListView(shrinkWrap: true, children: listWidget)),
            );
          },
        );
      },
    );
  }

  Widget buildInfoItem(DetailCelebPageProvider provider) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildActionBar(),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                      tag: widget.animationTag,
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CachedNetworkImage(
                            imageUrl: ImageUrl.getUrl(
                                widget.urlAvatar, ImageSize.w300),
                            fit: BoxFit.cover,
                            width: avatarWidth,
                            height: avatarHeight,
                            placeholder: (context, url) => Image.asset(
                              R.img_image_thumb,
                              width: avatarWidth,
                              height: avatarHeight,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              R.img_image_thumb,
                              width: avatarWidth,
                              height: avatarHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildNameWidget(provider.peopleDetailModel.name),
                      Text(
                        provider.peopleDetailModel.knownForDepartment ??
                            'Acting',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              provider.launchUrl('https://twitter.com/' +
                                  provider.externalIdsModel.instagramId);
                            },
                            child: Image.asset(
                              R.img_ic_twitter,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.launchUrl('https://www.instagram.com/' +
                                  provider.externalIdsModel.instagramId);
                            },
                            child: Image.asset(
                              R.img_ic_instagram,
                              width: 20,
                              height: 20,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ExpandableText(
              "Biography",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: buildBiographyWidget(
                      provider.peopleDetailModel.biography,
                      provider.peopleDetailModel.name))),
        ],
      ),
    );
  }

  Widget buildKnowFor(DetailCelebPageProvider provider) {
    if (provider.listKnowForAll.isNotEmpty) {
      return Container(
        width: Adapt.screenW(),
        height: heightItemKnowFor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.listKnowForAll.length,
          itemBuilder: (context, index) {
            var knowAsItem = provider.listKnowForAll[index];
            return buildKnowAsItem(knowAsItem);
          },
        ),
      );
    } else {
      return Container(
        width: Adapt.screenW(),
        height: heightItemKnowFor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return buildShimmerKnowAsItem();
          },
        ),
      );
    }
  }

  Widget buildShimmerKnowAsItem() {
    return Shimmer.fromColors(
        baseColor: AppTheme.bottomNavigationBarBackgroundt,
        highlightColor: AppTheme.item_bottomNavigation_selected,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: widthItemKnowFor,
          height: heightItemKnowFor,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widthItemKnowFor,
                  height: heightImageKnowFor,
                  decoration: BoxDecoration(
                      color: AppTheme.image_place_holder,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: widthItemKnowFor,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.image_place_holder,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: widthItemKnowFor,
                  height: 14,
                  decoration: BoxDecoration(
                      color: AppTheme.image_place_holder,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildKnowAsItem(CombinedCastData itemData) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: widthItemKnowFor,
      height: heightItemKnowFor,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: ImageUrl.getUrl(itemData.posterPath, ImageSize.w300),
                fit: BoxFit.cover,
                width: widthItemKnowFor,
                height: heightImageKnowFor,
                placeholder: (context, url) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemKnowFor,
                  height: heightImageKnowFor,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  R.img_image_thumb,
                  width: widthItemKnowFor,
                  height: heightImageKnowFor,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              itemData.originalTitle ?? "",
              maxLines: 2,
              style: TextStyle(height: 1, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBiographyWidget(String biography, String profileName) {
    if (biography == null) {
      return shimmerBiography();
    } else if (biography.isEmpty) {
      return Text(
        "We don't have a biography for $profileName",
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.normal),
      );
    } else {
      return ExpandableText(
        biography,
        maxLines: 5,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.normal),
      );
    }
  }

  Widget shimmerBiography() {
    return Shimmer.fromColors(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppTheme.image_place_holder,
          ),
          width: Adapt.screenW() - 20,
          height: 105,
        ),
        baseColor: AppTheme.bottomNavigationBarBackgroundt,
        highlightColor: AppTheme.item_list_background);
  }

  Widget buildNameWidget(String name) {
    if (name == null)
      return shimmerName();
    else
      return Text(
        name,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      );
  }

  Widget shimmerName() {
    return Shimmer.fromColors(
        child: Container(
          width: Adapt.screenW() / 3,
          height: 16,
          color: AppTheme.image_place_holder,
        ),
        baseColor: AppTheme.bottomNavigationBarBackgroundt,
        highlightColor: AppTheme.item_list_background);
  }

  Widget buildActionBar() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.all(10),
      child: GestureDetector(
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
    );
  }

  buildActing(DetailCelebPageProvider provider) {
    if (provider.listKnowForAll.isNotEmpty) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children:
              provider.listActing.map((e) => buildActingItem(e)).toList());
    } else {
      return Column(mainAxisSize: MainAxisSize.min, children: []);
    }
  }

  Widget buildActingItem(ActingModel actingModel) {

    return Column(
      children: [
        Divider(thickness: 1,color: AppTheme.bottomNavigationBarBackgroundt,indent: 100,),
        Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: AppTheme.bg_rank_top_rate),
                      ),
                      child: Text(
                        "${actingModel.year}",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        actingModel.tilte, style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }

  Widget buildShimmerActingItem() {
    return Container(
      width: 10,
      height: 10,
      color: Colors.deepOrange,
    );
  }
}
