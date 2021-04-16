import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PublisherBannerAdWidget extends StatefulWidget {
  PublisherBannerAdWidget(this.size);

  final AdSize size;

  @override
  State<StatefulWidget> createState() => PublisherBannerAdState();
}

class PublisherBannerAdState extends State<PublisherBannerAdWidget> {
  PublisherBannerAd _bannerAd;
  final Completer<PublisherBannerAd> bannerCompleter =
  Completer<PublisherBannerAd>();

  @override
  void initState() {
    super.initState();
    _bannerAd = PublisherBannerAd(
      adUnitId: '/6499/example/banner',
      request: PublisherAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[widget.size],
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$PublisherBannerAd loaded.');
          bannerCompleter.complete(ad as PublisherBannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$PublisherBannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$PublisherBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$PublisherBannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) =>
            print('$PublisherBannerAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PublisherBannerAd>(
      future: bannerCompleter.future,
      builder:
          (BuildContext context, AsyncSnapshot<PublisherBannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $PublisherBannerAd');
            }
        }

        return Container(
          width: _bannerAd.sizes[0].width.toDouble(),
          height: _bannerAd.sizes[0].height.toDouble(),
          color: Colors.blueGrey,
          child: child,
        );
      },
    );
  }
}