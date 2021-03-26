import 'package:flutter/cupertino.dart';

class CustomBottomNavigationBarProvider extends ChangeNotifier {
  int _index = 0;

  get currentIndex => _index;

  set currentIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
