import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/custom_alert.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';

class SettingDialog {
  showSettingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return CustomAlert(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Center(
                  child: Text(
                    "Setting",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Share with friends",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                ),
                onTap: () {
                  Share.share('https://play.google.com/store/apps/details?id=com.app.themoviedex.wallpaper');
                },
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,borderRadius: BorderRadius.only( bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
                  child: Center(
                    child: Text(
                      "Rate this app",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                ),
                onTap: () {
                  final InAppReview inAppReview = InAppReview.instance;
                  inAppReview.openStoreListing();
                },
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(5),
                ),
                onTap: () {
                  NavigatorUtil.popSinglePage(context);
                },
              ),
            ],
          )
        );
      },
    );
  }
}
