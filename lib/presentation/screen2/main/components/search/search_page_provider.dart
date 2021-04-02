import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:themoviedex/data/helper/box_name.dart';

class SearchPageProvider extends ChangeNotifier {
  bool _isEditingText = false;
  TextEditingController editingController = TextEditingController();
  String initialText = "Initial Text";
  String keySearch = "";
  List<String> listSuggest = List();
  SearchPageProvider() {
    listSuggest.addAll(Hive.box<String>(BoxName.BOX_SUGGEST_SEARCH).values);
    editingController.addListener(() {
      keySearch = editingController.text;
    });
  }

  void search() {

  }
}
