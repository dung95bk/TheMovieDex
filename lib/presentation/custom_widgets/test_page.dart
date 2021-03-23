import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    final texts = [
      Text(
        'looooo text1',
        textAlign: TextAlign.center,
      ),
      Text('short one', textAlign: TextAlign.center),
      Text('one more', textAlign: TextAlign.center),
      Text('one more', textAlign: TextAlign.center),
      Text('one more', textAlign: TextAlign.center),
      Text('one more', textAlign: TextAlign.center),
      Text('one more', textAlign: TextAlign.center),
    ];
    final children = <Widget>[
      for (int i = 0; i < texts.length; i++)
        LayoutId(
          id: '$_kLayoutKey$i',
          child: Container(
            color: Color.fromARGB(255, Random().nextInt(255),
                Random().nextInt(255), Random().nextInt(255)),
            child: texts[i],
          ),
        ),
    ];

    return Scaffold(
        appBar: AppBar(),
        body: LayoutBuilder(builder: (ctx, constrains) {
          return SafeArea(
              child: CustomMultiChildLayout(
            delegate: _CircularLayoutDelegate(texts, 14),
            children: children,
          ));
        }));
  }
}

const String _kLayoutKey = 'test';

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  _CircularLayoutDelegate(this.texts, this.fontSize);

  final double fontSize;
  final List<Text> texts;

  double _calcTextWidth(BoxConstraints constraints, Text textWidget) {
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: textWidget.data,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicWidth(fontSize).ceilToDouble();
  }

  @override
  void performLayout(Size size) {
    final textSizes = [
      for (final text in texts)
        _calcTextWidth(BoxConstraints.loose(size), text),
    ];

    final maxWidth = textSizes.fold<double>(0, (p, v) {
      final textWidth = v;
      return textWidth > p ? textWidth : p;
    });

    final textConstraint = BoxConstraints(
      maxWidth: maxWidth,
      minWidth: maxWidth,
      maxHeight: size.height,
    );

    for (int i = 0; i < texts.length; i++) {
      final String childId = '$_kLayoutKey$i';

      if (hasChild(childId)) {
        layoutChild('$_kLayoutKey$i', textConstraint);

        positionChild(
          childId,
          Offset(maxWidth * i, 0),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      oldDelegate.texts != texts;
}
