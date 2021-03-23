import 'dart:io';
import 'package:themoviedex/presentation/util/ads_util.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:themoviedex/presentation/screen/detail_image/detail_image_page.dart';
import 'package:themoviedex/presentation/screen/listwallpaper/list_wallpaper_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListWallpaperPage extends StatefulWidget {
  ListWallpaperPage({Key key}) : super(key: key);

  @override
  _ListWallpaperPageState createState() {
    return _ListWallpaperPageState();
  }
}

class _ListWallpaperPageState extends State<ListWallpaperPage> {
  int selectedIndex = 0;
  List<String> names = List<String>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  List<Tab> rows = [];
  Box<ImageModeHive> boxImage;
  Widget targetWidget;

  @override
  void initState() {
    names.add("Categories");
    names.add("Hot");
    boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ListWallpaperProvider>(context, listen: false)
        ..firstCallData()
        ..listener();
    });



  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> test() async {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ListWallpaperProvider>().reset(),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Consumer(
              builder: (context, ListWallpaperProvider provider, child) =>
                  buildListView(context, provider.listImage, provider),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context, List<ImageModelDomain> listImage,
      ListWallpaperProvider provider) {
    final orientation = MediaQuery.of(context).orientation;
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
    return GestureDetector(
      onTap: () async {
        targetWidget = DetailImagePage(
          image: image,
        );

      },
      child: Container(
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
                  Provider.of<ListWallpaperProvider>(context, listen: false)
                      .favorite(image);
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
      ),
    );
  }
}
