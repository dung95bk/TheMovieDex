import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/custom_widgets/custom_alert.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';


class OptionDialog {
  showOtionDialog(BuildContext context, String title, String content, Function nagative,  Function positive) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return CustomAlert(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15.0),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                SizedBox(height: 25.0),
                Text(
                  content,
                  style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14.0
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40.0,
                      width: 130.0,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        borderSide: BorderSide(
                          color: Colors.deepPurple
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: Colors.deepPurple
                          ),
                        ),
                        color: Colors.white,
                        onPressed: () => nagative(),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      width: 130.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Text (
                          'Yes',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                          color: Colors.deepPurple,
                        onPressed: () => positive(),
                      ),
                    )

                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
