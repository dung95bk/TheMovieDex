import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/category_detail/category_detail_provider.dart';
import 'package:themoviedex/presentation/screen/detail_image/detail_image_page.dart';
import 'package:themoviedex/presentation/screen/listwallpaper/list_wallpaper_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryDetailPage extends StatefulWidget {
  String categoryId = "";

  CategoryDetailPage({this.categoryId, Key key}) : super(key: key);

  @override
  _CategoryDetailPageState createState() {
    return _CategoryDetailPageState();
  }
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Box<ImageModeHive> boxImage;
  @override
  void initState() {
    super.initState();
    boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          value:  CategoryDetailProvider(widget.categoryId),
          child: Consumer(
            builder: (context, CategoryDetailProvider categoryDetailProvider, child) {
              return RefreshIndicator(
                onRefresh: () => context.read<CategoryDetailProvider>().reset(),
                child: Column(
                  children: [
                    buildAppBar(categoryDetailProvider.categoryName),
                    Expanded(
                      flex: 1,
                      child: buildListView(context, categoryDetailProvider.listImage, categoryDetailProvider),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  buildAppBar(String name) {
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
              name,
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
      CategoryDetailProvider provider) {
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
      onTap: () =>
          NavigatorUtil.pushPage(context, DetailImagePage(image: image,)),
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
                imageUrl: image.sourceUrl,
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
                      isFav = box
                          .get(image.id)
                          .isFav;
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
