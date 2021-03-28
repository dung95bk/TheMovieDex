import 'package:flutter/cupertino.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';

class MoviesPageProviderProvider extends ChangeNotifier {
  List<ResponseModel> movieList = List<ResponseModel>();

  MoviesPageProviderProvider() {

  }

  void getMovie() async {
    if(movieList.isNotEmpty) return;
    movieList.clear();

  }
}
