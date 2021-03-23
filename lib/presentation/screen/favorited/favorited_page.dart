import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/favorited/favorited_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritedPage extends StatefulWidget {
  FavoritedPage({Key key}) : super(key: key);

  @override
  _FavoritedPageState createState() {
    return _FavoritedPageState();
  }
}

class _FavoritedPageState extends State<FavoritedPage> {
  FavoritedProvider favoritedProvider;
  Box<ImageModeHive> boxImage;

  @override
  void initState() {
    boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    super.initState();
    favoritedProvider = FavoritedProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: favoritedProvider,
          builder: (context, child) => SafeArea(
            child: Column(
              children: [
                buildAppBar(),
                Expanded(
                  child: Consumer(
                    builder: (context, FavoritedProvider provider, child) =>
                        buildListView(context, provider.listImage, provider),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return Container(
      height: kToolbarHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              NavigatorUtil.popSinglePage(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Align(alignment: Alignment.centerLeft,
                  child: Image.asset(R.img_ic_close, fit: BoxFit.cover, width: 16, height: 16,)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
             "Favorite",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal

              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context, List<ImageModelDomain> listImage,
      FavoritedProvider provider) {
    final orientation = MediaQuery.of(context).orientation;
    if(listImage.length == 0) {
      return Center(
        child: Container(
          child: Text(
            "Empty",
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontSize: 32,
              decoration: TextDecoration.none
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      controller: provider.controller,
      itemCount: listImage.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 9 / 16,
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        return buildItemGridView(context, listImage[index]);
      },
    );
  }

  Widget buildItemGridView(BuildContext context, ImageModelDomain image) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 5.0,
              color: Colors.deepPurpleAccent,
              offset: Offset(1.0, 1.0))
        ],
      ),
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: image.mediumUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5.0,
                          color: image.randomColor,
                          offset: Offset(1.0, 1.0))
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 14,
            right: 14,
            child: GestureDetector(

              onTap: () {
                Provider.of<FavoritedProvider>(context, listen: false).favorite(image);
              },
              child: ValueListenableBuilder(
                valueListenable: boxImage.listenable(keys: [image.id]),
                builder: (context, Box<ImageModeHive> box, child) {
                  var isFav = false;
                  if (box.get(image.id) != null) {
                    isFav = box.get(image.id).isFav;
                  }
                  return Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white, size: 40);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


