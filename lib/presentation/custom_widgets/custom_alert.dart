import 'dart:ui';

import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final Widget child;

  CustomAlert({Key key, @required this.child}) : super(key: key);

  double deviceWidth;
  double deviceHeight;
  double dialogHeight;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size viewSize = MediaQuery.of(context).size;
    deviceWidth =
        orientation == Orientation.portrait ? viewSize.width : viewSize.height;
    deviceHeight =
        orientation == Orientation.landscape ? viewSize.height : viewSize.width;
    dialogHeight = deviceHeight * 0.5;
    return MediaQuery(
        data: MediaQueryData(),
        child: GestureDetector(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(child: Stack(
                    children: [
                      Center (
                        child: Container(
                          width: deviceWidth * 0.9,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),

                              ),
                              child: child,
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
