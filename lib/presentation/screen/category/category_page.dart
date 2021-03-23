import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:themoviedex/data/model/local/category_model.dart';
import 'package:themoviedex/domain/model/category_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/category/category_provider.dart';
import 'package:themoviedex/presentation/screen/category_detail/category_detail_page.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() {
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    print("initStateCategory");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("initStateCategory-addPostFrameCallback");

      Provider.of<CategoryProvider>(context, listen: false)
          .initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, CategoryProvider provider, child) =>
          buildListView(context, provider.listCategory, provider),
    );
  }

  Widget buildListView(BuildContext context,
      List<CategoyModelDomain> listCategory, CategoryProvider provider) {
    print("buildListView: ${listCategory.length}");
    return ListView.builder(
      controller: provider.controller,
      itemCount: listCategory.length,

      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        CategoyModelDomain categoryModel = listCategory[index];
        return createItemList(context, categoryModel);
      },
    );
  }

  Widget createItemList(BuildContext buildContext,
      CategoyModelDomain categoryModel) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.pushPage(context, CategoryDetailPage(categoryId: categoryModel.id,));
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
        child: Stack(
          alignment: FractionalOffset(0.5, 0.9),
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    width: constraints.maxWidth,
                    height: 240,
                    imageUrl: categoryModel.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5.0,
                                color: categoryModel.randomColor,
                                offset: Offset(1.0, 1.0))
                          ],
                        ),
                      );
                    },
                  ),
                );

              },

            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  categoryModel.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
