import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/screen2/test/videoplayeritem.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/videourl.dart';
import 'package:video_player/video_player.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
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
    Adapt.initContext(context);

    return  Container(
     padding: EdgeInsets.fromLTRB(Adapt.px(30), 0, Adapt.px(30), Adapt.px(30)),
     child: Card(
       elevation: 2.0,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           VideoPlayerItem(
             vc: VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
             coverurl: 'https://i.ytimg.com/vi/vM-Bja2Gy04/hqdefault.jpg',
             showplayer: true,
           ),
           Padding(
             padding: EdgeInsets.all(Adapt.px(20)),
             child: Text(
               "d.name",
               style: TextStyle(
                   color: Colors.black,
                   fontSize: Adapt.px(35),
                   fontWeight: FontWeight.w500),
             ),
           ),
         ],
       ),
     ),
   );
  }
}