class AdsUtil {
  static int COUNT_SHOW_AD = 3;
  static int currentCountShowAd = COUNT_SHOW_AD;

  static bool isShowAd() {
    currentCountShowAd -= 1;
    if (currentCountShowAd == 0) {
      currentCountShowAd = COUNT_SHOW_AD;
      return true;
    }
    return false;
  }
}
