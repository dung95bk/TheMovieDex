import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:themoviedex/presentation/screen2/testads/banner_ads.dart';
import 'package:themoviedex/presentation/screen2/testads/constants.dart';
import 'package:themoviedex/presentation/screen2/testads/native_ads.dart';
import 'package:themoviedex/presentation/screen2/testads/publisher_banner_ads.dart';
import 'package:themoviedex/presentation/screen2/testads/resuable_inline_example.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class MyTestApp extends StatefulWidget {
  @override
  _MyTestAppState createState() => _MyTestAppState();
}

class _MyTestAppState extends State<MyTestApp> {
  static final AdRequest request = AdRequest(
    testDevices: <String>[testDevice],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  RewardedAd _rewardedAd;
  bool _rewardedReady = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
          tagForChildDirectedTreatment:
          TagForChildDirectedTreatment.unspecified))
          .then((void value) {
        createInterstitialAd();
        createRewardedAd();
      });
    });
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  void createRewardedAd() {
    _rewardedAd ??= RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('${ad.runtimeType} loaded.');
            _rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('${ad.runtimeType} failed to load: $error');
            ad.dispose();
            _rewardedAd = null;
            createRewardedAd();
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

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Plugin example app'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'InterstitialAd':
                  if (!_interstitialReady) return;
                  _interstitialAd.show();
                  _interstitialReady = false;
                  _interstitialAd = null;
                  break;
                case 'RewardedAd':
                  if (!_rewardedReady) return;
                  _rewardedAd.show();
                  _rewardedReady = false;
                  _rewardedAd = null;
                  break;
                case 'ReusableInlineExample':
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ReusableInlineExample()),
                  );
                  break;
                default:
                  throw AssertionError('unexpected button: $result');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '$InterstitialAd',
                child: Text('$InterstitialAd'),
              ),
              PopupMenuItem<String>(
                value: '$RewardedAd',
                child: Text('$RewardedAd'),
              ),
              PopupMenuItem<String>(
                value: 'ReusableInlineExample',
                child: Text('Reusable Inline Ads Object Example'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          cacheExtent: 500,
          itemCount: 100,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 40,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            if (index % 2 == 0) {
              return Text(
                Constants.placeholderText,
                style: TextStyle(fontSize: 24),
              );
            }

            final int adIndex = (index / 2).floor();
            Widget adWidget;
            if (adIndex % 3 == 0) {
              adWidget = BannerAdWidget(AdSize.banner);
            } else if (adIndex % 3 == 1) {
              adWidget = PublisherBannerAdWidget(AdSize.largeBanner);
            } else {
              adWidget = NativeAdWidget();
            }
            return Center(child: adWidget);
          },
        ),
      ),
    );
  }
}


