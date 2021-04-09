import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/model/local/task_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/detail_task/detail_task_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:provider/provider.dart';

class DetailTaskPage extends StatefulWidget {
  String taskId;

  DetailTaskPage(this.taskId);

  @override
  _DetailTaskPageState createState() {
    return _DetailTaskPageState();
  }
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  DetailTaskProvider detailTaskProvider;

  @override
  void initState() {
    super.initState();
    detailTaskProvider = DetailTaskProvider(widget.taskId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ChangeNotifierProvider.value(
        value: detailTaskProvider,
        builder: (context, child) =>
            Consumer(builder: (context, DetailTaskProvider detailTaskProvider, child) =>  Column(children: getContentPage(detailTaskProvider))),
      )),
    );
  }

  List<Widget> getContentPage(DetailTaskProvider detailTaskProvider) {
    if (detailTaskProvider.guideModelDomain == null) {
      return <Widget>[buildAppBar(""), SizedBox()];
    } else {
      return <Widget>[
        buildAppBar(detailTaskProvider.guideModelDomain.name),
        if (detailTaskProvider.guideModelDomain.thumbnailUrl?.isEmpty)
          Image.asset(R.img_ic_task_clear_asteroids)
        else
          CachedNetworkImage(
            imageUrl: detailTaskProvider.guideModelDomain.thumbnailUrl,
            fit: BoxFit.cover,
          ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child:
                getDescription(detailTaskProvider.guideModelDomain.description))
      ];
    }
  }

  Widget getDescription(String description) {
    return Container();
  }

  buildAppBar(String title) {
    return Container(
      height: kToolbarHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              NavigatorUtil.popSinglePage(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    R.img_ic_close,
                    fit: BoxFit.cover,
                    width: 16,
                    height: 16,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
