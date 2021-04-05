import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/data/remote/models/enums/imagesize.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/detail_celeb/detail_celeb_page_provider.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/imageurl.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class DetailCelebPage extends StatefulWidget {
  int celebId;

  DetailCelebPage({Key key, @required this.celebId}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    provider = DetailCelebPageProvider(widget.celebId);
    margin = Adapt.px(20);
    avatarWidth = (Adapt.screenW() - margin * 2) / 4;
    avatarHeight = avatarWidth * 16 / 9;
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
        // return ListView.builder(
        //   itemCount: 1,
        //   itemBuilder: (context, index) {
        //
        //   },
        // );
        return Consumer(
          builder: (context, DetailCelebPageProvider provider, child) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: AppTheme.bottomNavigationBarBackground_light,
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildActionBar(),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: ImageUrl.getUrl(
                                      provider.getThumbCeleb(), ImageSize.w300),
                                  fit: BoxFit.cover,
                                  width: avatarWidth,
                                  height: avatarHeight,
                                  placeholder: (context, url) => Image.asset(
                                    R.img_image_thumb,
                                    width: avatarWidth,
                                    height: avatarHeight,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    R.img_image_thumb,
                                    width: avatarWidth,
                                    height: avatarHeight,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildNameWidget(
                                      provider.peopleDetailModel.name),
                                  Text(
                                    provider.peopleDetailModel
                                            .knownForDepartment ??
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
                                          provider.launchUrl(
                                              'https://twitter.com/' +
                                                  provider.externalIdsModel
                                                      .instagramId);
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
                                          provider.launchUrl(
                                              'https://www.instagram.com/' +
                                                  provider.externalIdsModel
                                                      .instagramId);
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
                        child: Text(
                          "Biography",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Container( margin: EdgeInsets.only(left: 10, right: 10, top: 10), child: buildBiographyWidget(provider.peopleDetailModel.biography)),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBiographyWidget(String biography) {
    print("biography:${biography}");
    if(biography == null) {
      return shimmerBiography();
    } else {
      return Text(
        biography,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
      );
    }
  }

  Widget shimmerBiography() {
    return Shimmer.fromColors(child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),       color: AppTheme.image_place_holder,
        ),

      width: Adapt.screenW() - 20,
      height: 460,
    ),  baseColor: AppTheme.bottomNavigationBarBackgroundt,
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
    return Shimmer.fromColors(child: Container(
      width: Adapt.screenW() / 3,
      height: 16,
      color: AppTheme.image_place_holder,
    ),  baseColor: AppTheme.bottomNavigationBarBackgroundt,
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

}
