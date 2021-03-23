import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/custom_widgets/exit_dialog.dart';
import 'package:themoviedex/presentation/custom_widgets/notification_dialog.dart';
import 'package:themoviedex/presentation/lib/extend_image/src/extended_image.dart';
import 'package:themoviedex/presentation/lib/extend_image/src/extended_image_utils.dart';
import 'package:themoviedex/presentation/lib/extend_image/src/gesture/extended_image_gesture.dart';
import 'package:themoviedex/presentation/lib/extend_image/src/gesture/extended_image_gesture_utils.dart';
import 'package:themoviedex/presentation/screen/detail_image/detail_image_provider.dart';
import 'package:themoviedex/presentation/screen/detail_task/detail_task_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:themoviedex/presentation/util/screen_util.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class DetailImagePage extends StatefulWidget {
  ImageModelDomain image;

  DetailImagePage({this.image, Key key}) : super(key: key);

  @override
  _DetailImagePageState createState() {
    return _DetailImagePageState();
  }
}

class _DetailImagePageState extends State<DetailImagePage> {
  DetailImageProvider detailImageProvider;
  Box<ImageModeHive> boxImage;
  final GlobalKey<ExtendedImageGestureState> gestureKey =
  GlobalKey<ExtendedImageGestureState>();
  @override
  void initState() {
    boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    super.initState();
    detailImageProvider = DetailImageProvider(widget.image);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = getScreenSize(context);
    return Container(
      color: Colors.black,
      child: ChangeNotifierProvider.value(
        value: detailImageProvider,
        builder: (context, child) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: ExtendedImage.network(
                        widget.image.sourceUrl,
                        width : getScreenSize(context).item1,
                        fit: BoxFit.fitWidth,
                        mode: ExtendedImageMode.gesture,
                        extendedImageGestureKey: gestureKey,
                        initGestureConfigHandler: (ExtendedImageState state) {
                          return GestureConfig(
                            minScale: 1,
                            animationMinScale: 1,
                            maxScale: 4.0,
                            animationMaxScale: 4.5,
                            speed: 1.0,
                            inertialSpeed: 100.0,
                            initialScale: 1.0,
                            inPageView: true,

                            initialAlignment: InitialAlignment.center,
                            gestureDetailsIsChanged: (GestureDetails details) {
                              //print(details.totalScale);
                            },
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: buildAppBar(),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: buildBottomBar(screenWidth.item1)),
                    Builder(builder: (context) {
                      int state =
                          context.watch<DetailImageProvider>().currentState;
                      switch (state) {
                        case DetailImageProvider.STATE_DOWNLOAD_FINISH:
                          {
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              context.read<DetailImageProvider>().resetState();
                              OptionDialog().showOtionDialog(context,
                                  "Download Success", "Do you want open it?", () {
                                    NavigatorUtil.popSinglePage(context);
                                  }, () {
                                    NavigatorUtil.popSinglePage(context);
                                    context
                                        .read<DetailImageProvider>()
                                        .openImageFile();
                                  });
                            });
                            break;
                          }
                        case DetailImageProvider.STATE_DOWNLOAD_ERROR:
                          {
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              context.read<DetailImageProvider>().resetState();
                              NotificationDialog().showNotificationDialog(
                                  context,
                                  "Download Failed",
                                  "Wallpaper could not be downloaded this time",
                                      () {
                                    NavigatorUtil.popSinglePage(context);
                                  });
                            });
                            break;
                          }
                        case DetailImageProvider.STATE_SET_WALLPAPER_SUCCESS:
                          {
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              context.read<DetailImageProvider>().resetState();
                              NotificationDialog().showNotificationDialog(
                                  context, "Set Wallpaper", "Success", () {
                                NavigatorUtil.popSinglePage(context);
                              });
                            });
                            break;
                          }
                        case DetailImageProvider.STATE_SET_WALLPAPER_ERROR:
                          {
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              context.read<DetailImageProvider>().resetState();
                              NotificationDialog().showNotificationDialog(
                                  context,
                                  "Set Wallpaper",
                                  "Wallpaper could not be set this time", () {
                                NavigatorUtil.popSinglePage(context);
                              });
                            });
                            break;
                          }
                      }
                      return SizedBox();
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(double width) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () =>
                    Provider.of<DetailImageProvider>(context, listen: false)
                        .downloadImage(true),
                child: buildItemBottomBar(
                    "Download",
                    Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
                    true),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Builder(
                builder: (context) => GestureDetector(
                      onTap: () => Provider.of<DetailImageProvider>(context,
                              listen: false)
                          .setWallpaper(),
                      child: buildItemBottomBar(
                          "Set Wallpaper",
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          false),
                    )),
          ),
        ],
      ),
    );
  }

  Widget buildItemBottomBar(String text, Icon icon, bool isLeft) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isLeft
                ? [
                    Colors.lightBlue[800].withOpacity(0.7),
                    Colors.blue[800].withOpacity(0.7),
                    Colors.purple.withOpacity(0.7)
                  ]
                : [
                    Colors.purple.withOpacity(0.7),
                    Colors.blue[800].withOpacity(0.7),
                    Colors.lightBlue[800].withOpacity(0.7)
                  ]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  buildAppBar() {
    return Container(
      height: kToolbarHeight,
      color: Colors.black.withOpacity(0.1),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              NavigatorUtil.popSinglePage(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    R.img_ic_close,
                    fit: BoxFit.cover,
                    width: 24,
                    height: 24,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
