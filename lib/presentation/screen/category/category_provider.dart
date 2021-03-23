import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/http.dart';
import 'package:themoviedex/data/remote/request/get_category_request.dart';
import 'package:themoviedex/data/remote/response/get_category_response_entity.dart';
import 'package:themoviedex/domain/model/category_model_domain.dart';


class CategoryProvider extends ChangeNotifier {
    List<CategoyModelDomain> listCategory = List<CategoyModelDomain>();
    ScrollController controller = ScrollController();
    int currentPageIndex = 1;
    int take = 13;
    bool loadingMore = false;
    bool allowLoadMore = true;
    void initData()  {
        if(listCategory.length == 0 && !loadingMore) {
            getListCategory();
        }
    }

    listener() {
        // controller.addListener(() {
        //     if (controller.position.pixels == controller.position.maxScrollExtent) {
        //         if (!loadingMore) {
        //             paginate();
        //             // Animate to bottom of list
        //             Timer(Duration(milliseconds: 100), () {
        //                 controller.animateTo(
        //                     controller.position.maxScrollExtent,
        //                     duration: Duration(milliseconds: 100),
        //                     curve: Curves.easeIn,
        //                 );
        //             });
        //         }
        //     }
        // });
    }

    void paginate() {
        print("paginate");
        if (allowLoadMore && !loadingMore) {
            Timer(Duration(milliseconds: 100), () {
                controller.jumpTo(controller.position.maxScrollExtent);
            });
            currentPageIndex = currentPageIndex + 1;
            notifyListeners();
            getListCategory();
        }
    }

    void getListCategory() async{
        print("getListCategory");
        loadingMore = true;
        GetcategoryRequest getCategoryRequest =
        GetcategoryRequest.fromData(currentPageIndex, take);
        Response response;
        try {
            response = await Http.instance.getListCategory(getCategoryRequest);
        } catch (e) {
        }
        if (response != null && response.statusCode == 200) {
            GetCategoryResponse getTokenResponse =
            GetCategoryResponse().fromJson(response.data);
            var listData = getTokenResponse.data;
            print("Length category: ${listData.length}");
            if (listData.length > 0 && listCategory.length >= take) {
                allowLoadMore = true;
            } else {
                allowLoadMore = false;
            }

            listData.forEach((element) {
                listCategory.add(CategoyModelDomain.fromData(
                    false,
                    element.id,
                    element.name,
                    element.slug,
                    element.thumbnailUrl));
            });
            print("Length category after: ${listCategory.length}");

            notifyListeners();
        } else {
            allowLoadMore = false;
        }

        loadingMore = false;
   }
}