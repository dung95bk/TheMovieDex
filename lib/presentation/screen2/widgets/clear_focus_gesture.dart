import 'package:flutter/material.dart';

class ClearFocusGestureDetector extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  ClearFocusGestureDetector({Key key, this.onTap, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        onTap();
      },
      child: child,
    );
  }
}
