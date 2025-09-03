import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Utils/common.dart';

class NativeAdBannerWidget extends StatefulWidget {
  @override
  _NativeAdBannerWidgetState createState() => _NativeAdBannerWidgetState();
}

class _NativeAdBannerWidgetState extends State<NativeAdBannerWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _nativeAd = NativeAd(
      adUnitId: Common.native_ad_id, // Test Native Ad Unit ID
      factoryId: 'listTile', // Same as registered in Android (see step 5)
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
            height: 265,
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox(); // Empty space before ad loads
  }
}
