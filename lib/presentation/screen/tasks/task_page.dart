import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/model/local/task_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/custom_widgets/custom_tabbar.dart';
import 'package:themoviedex/presentation/screen/detail_task/detail_task_page.dart';
import 'package:themoviedex/presentation/screen/tasks/task_page_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:themoviedex/presentation/util/screen_util.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  GuideModelDomain taskData;

  TasksPage({Key key, this.taskData}) : super(key: key);

  @override
  _TasksPageState createState() {
    return _TasksPageState();
  }
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TaskPageProvider>(context, listen: false)
          .initData(widget.taskData);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, TaskPageProvider provider, child) {
        return GestureDetector(
          child: provider.getTabName().length == 0
              ? SizedBox()
              : Column(
                  children: [
                    HomeCustomPage(provider.getTabName(), (index) {
                      provider.changePage(index);
                    }, provider.tabIndex),
                    Expanded(
                      child: buildList(context, provider),
                    )
                  ],
                ),
        );
      },
    );
  }

  Widget buildList(BuildContext context, TaskPageProvider provider) {
    double imageWidth = (getScreenSize(context).item1 - 20) * 0.4;
    double imageHeight = imageWidth * 9 / 16;
    List<GuideModelDomain> list = provider.getTabData();

    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: list.length,
          itemBuilder: (context, index) {
            GuideModelDomain taskModel = list[index];
            return buildItem(context, taskModel, imageWidth, imageHeight);
          },
        ));
  }

  Widget buildItem(BuildContext context, GuideModelDomain item,
      double imageWidth, double imageHeight) {
    print("Item task url: ${item.thumbnailUrl}");
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        NavigatorUtil.pushPage(context, DetailTaskPage(item.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (item.thumbnailUrl?.isEmpty)
                Image.asset(
                  R.img_ic_task_clear_asteroids,
                  fit: BoxFit.cover,
                  width: imageWidth,
                  height: imageHeight,
                )
              else
                CachedNetworkImage(
                  imageUrl: item.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: imageWidth,
                  height: imageHeight,
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(item.name,
                        style: GoogleFonts.abel(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        )),
                    Text(item.slug,
                        style: GoogleFonts.abel(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
