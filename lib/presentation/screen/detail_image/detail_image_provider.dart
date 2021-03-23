import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:themoviedex/data/helper/box_name.dart';
import 'package:themoviedex/data/model/local/image_model_hive.dart';
import 'package:themoviedex/data/model/mapper/image_model_mapper.dart';
import 'package:themoviedex/domain/model/image_model_domain.dart';
import 'package:hive/hive.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class DetailImageProvider extends ChangeNotifier {
  ImageModelDomain imageModelDomain;
  int currentState = STATE_INIT;

  bool isDownloadSuccess = false;
  String imageDownloadedId = "";

  DetailImageProvider(this.imageModelDomain) {
    notifyListeners();
  }

  static const STATE_DOWNLOAD_FINISH = 0;
  static const STATE_SET_WALLPAPER_SUCCESS = 1;
  static const STATE_SET_WALLPAPER_ERROR = 2;
  static const STATE_DOWNLOAD_ERROR = 3;
  static const STATE_INIT = -1;

  void favorite(ImageModelDomain image) {
    image.isFav = !image.isFav;
    var boxImage = Hive.box<ImageModeHive>(BoxName.BOX_IMAGE);
    var foundImage = boxImage.get(image.id);
    if (foundImage == null) {
      boxImage.put(image.id, ImageModelMapper.toHiveObject(image));
    } else {
      foundImage.delete();
    }
  }

  void resetState() {
    currentState = STATE_INIT;
  }

  void saveDownloaded(String imageId, String path) {
    var boxImage = Hive.box<String>(BoxName.BOX_DOWNLOADED_IMAGE_PATH);
    boxImage.put(imageId, path);
  }

  void setWallpaper() async {
    if (!isDownloadSuccess) {
      await downloadImage(false);
    }
    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    String result;
    try {
      var path = await ImageDownloader.findPath(imageDownloadedId);
      result = await WallpaperManager.setWallpaperFromFile(path, location);
      currentState = STATE_SET_WALLPAPER_SUCCESS;
    } on PlatformException {
      currentState = STATE_SET_WALLPAPER_ERROR;
      result = 'Failed to get wallpaper.';
    }
    notifyListeners();
  }

  Future<void> downloadImage(bool isShowPopupSuccess) async {
    if (isDownloadSuccess) {
      currentState = STATE_DOWNLOAD_FINISH;
      notifyListeners();
      return;
    }
    try {
      // Saved with this method.
      ImageDownloader.callback(
          onProgressUpdate: (String imageId, int progress) {
            print("Progess:${progress}");
            EasyLoading.showProgress((progress / 100).toDouble(),
                status: '${(progress).toStringAsFixed(0)}%');

            if (progress >= 100) {
              EasyLoading.dismiss();
            }
          });

      imageDownloadedId = await ImageDownloader.downloadImage(
          imageModelDomain.sourceUrl,
          destination: AndroidDestinationType.custom(
              directory: "AmongUSWallpaper")
            ..inExternalFilesDir()
            ..subDirectory("wallpaper/${imageModelDomain.id}.png"));

      if (imageDownloadedId == null) {
        return;
      }
      saveDownloaded(imageModelDomain.id, imageDownloadedId);
      isDownloadSuccess = true;
      if (isShowPopupSuccess) {
        currentState = STATE_DOWNLOAD_FINISH;
        notifyListeners();

        print("Download success");
      }
    } on PlatformException catch (error) {
      print(error);
      currentState = STATE_DOWNLOAD_ERROR;

    }
  }

  void openImageFile() async {
    var path = await ImageDownloader.findPath(imageDownloadedId);

    if (path != null) {
      print("open != null");

      await ImageDownloader.open(path);
    }
  }
}