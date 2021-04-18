import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class AdsManager {
  AdsManager._();

  static final AdsManager _instance = AdsManager._();

  static AdsManager get instance => _instance;

  InterstitialAd _interstitialAd;
  bool interstitialReady = false;

  RewardedAd _rewardedAd;
  bool rewardedReady = false;

  BannerAd _bannerAd;
  bool bannerAdIsLoaded = false;
  NativeAd nativeAd;
  bool nativeAdIsLoaded = false;
  PublisherBannerAd _publisherBannerAd;
  bool publisherBannerAdIsLoaded = false;

  int timesRetryLoadInterstitialAd = 0;
  int timesRetryLoadVideoRewardAd = 0;

  static const int maxRetryLoadBanner = 4;
  static const int maxRetryLoadInterstitialAd = 4;
  static const int maxRetryLoadVideoReward = 4;

  static const int timesToShowInterstitialAd = 4;
  int countToShowInterstitialAd = 0;

  Widget targetWidget;
  BuildContext targetContext;
  static final AdRequest request = AdRequest(
    testDevices: <String>[testDevice],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void init() {
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((void value) {
        createInterstitialAd();
        // createRewardedAd();
      });
    });
  }

  bool isCanShowNativeAds() {
    return nativeAdIsLoaded && nativeAd != null;
  }

  void reset() {
    timesRetryLoadInterstitialAd = 0;
    timesRetryLoadVideoRewardAd = 0;

    _interstitialAd = null;
    interstitialReady = false;

    _rewardedAd = null;
    rewardedReady = false;

    _bannerAd = null;
    bannerAdIsLoaded = false;
    nativeAd = null;
    nativeAdIsLoaded = false;
    _publisherBannerAd = null;
    publisherBannerAdIsLoaded = false;
  }

  void createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            bannerAdIsLoaded = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
          onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
        ),
        request: AdRequest())
      ..load();
  }

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void createNativeAd(ValueChanged<bool> adsLoaded) {
    nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511',
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          nativeAdIsLoaded = true;
          adsLoaded(nativeAdIsLoaded);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
      ),
    )..load();
  }

  void disposeNativeAds() {
    nativeAdIsLoaded = false;
    nativeAd?.dispose();
    nativeAd = null;
  }

  void createPublisherAd() {
    _publisherBannerAd = PublisherBannerAd(
      adUnitId: '/6499/example/banner',
      request: PublisherAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.largeBanner],
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$PublisherBannerAd loaded.');
          publisherBannerAdIsLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$PublisherBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$PublisherBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$PublisherBannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) =>
            print('$PublisherBannerAd onApplicationExit.'),
      ),
    )..load();
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          timesRetryLoadInterstitialAd += 1;
          if (timesRetryLoadInterstitialAd <= maxRetryLoadInterstitialAd) {
            createInterstitialAd();
          }
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd();
          _showTargetWidget();
          resetTarget();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  void resetTarget() {
    targetContext = null;
    targetWidget = null;
  }

  void _showTargetWidget() {
    if (targetContext != null && targetWidget != null) {
      NavigatorUtil.pushPageWithInterstitialAd(targetContext, targetWidget);
    }
  }

  void createRewardedAd() {
    _rewardedAd ??= RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('${ad.runtimeType} loaded.');
            rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('${ad.runtimeType} failed to load: $error');
            ad.dispose();
            _rewardedAd = null;
            timesRetryLoadVideoRewardAd += 1;
            if (timesRetryLoadVideoRewardAd <= maxRetryLoadVideoReward) {
              createRewardedAd();
            }
          },
          onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
          onAdClosed: (Ad ad) {
            print('${ad.runtimeType} closed.');
            ad.dispose();
            createRewardedAd();
          },
          onApplicationExit: (Ad ad) =>
              print('${ad.runtimeType} onApplicationExit.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
            print(
              '$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})',
            );
          }),
    )..load();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  void showInterstitialAd(BuildContext context, Widget targetWidget) {
    if (!interstitialReady) {
      NavigatorUtil.pushPage(context, targetWidget);
      return;
    }

    countToShowInterstitialAd += 1;
    if (countToShowInterstitialAd != timesToShowInterstitialAd) {
      print("changepage");
      NavigatorUtil.pushPage(context, targetWidget);
      return;
    } else {
      countToShowInterstitialAd = 0;
    }
    this.targetWidget = targetWidget;
    this.targetContext = context;
    print("isReady:${interstitialReady}");

    _interstitialAd.show();
    interstitialReady = false;
    _interstitialAd = null;
  }

  void showRewardedAd() {
    if (!rewardedReady) return;
    _rewardedAd.show();
    rewardedReady = false;
    _rewardedAd = null;
  }
}
