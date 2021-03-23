import 'package:flutter/material.dart';

class Testpage2 extends StatefulWidget {
  Testpage2({Key key}) : super(key: key);

  @override
  _Testpage2State createState() {
    return _Testpage2State();
  }
}

class _Testpage2State extends State<Testpage2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Name",
              ),
              Text(
                ":",
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: TextField(),
          ),
        )
      ],
    );
  }
}