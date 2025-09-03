import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Utils/common.dart';
import 'first_screen.dart';
import 'services/app_open_ad_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _noAds = false;

  @override
  void initState() {
    super.initState();
    _initNoAds();
    // Navigate to player selection screen after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
      );
    });
  }

  Future<void> _initNoAds() async {
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    if (_noAds) return;
    _bannerAd = BannerAd(
      adUnitId: Common.bannar_ad_id,
      // Android test banner ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    if (_noAds) return;
    InterstitialAd.load(
      adUnitId: Common.interstitial_ad_id,
      // Android test interstitial ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd(VoidCallback onAdClosed) {
    if (_noAds) {
      onAdClosed();
      return;
    }
    if (_interstitialAd != null) {
      // Prevent app open ad on the next resume caused by interstitial
      AppOpenAdManager.suppressNextOnResume();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onAdClosed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                "assets/images/loader.gif",
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
