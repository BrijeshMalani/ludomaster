import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ludomaster/services/app_lifecycle_reactor.dart';
import 'package:ludomaster/services/app_open_ad_manager.dart';
import 'package:ludomaster/splash_screen.dart';
import 'package:ludomaster/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/common.dart';
import 'ludo_provider.dart';

final appOpenAdManager = AppOpenAdManager();

Future<void> updateNoAdsState() async {
  final prefs = await SharedPreferences.getInstance();
  final noAds = prefs.getBool('no_ads_purchased') ?? false;
  AppOpenAdManager.disableAds = noAds;
  if (noAds) {
    appOpenAdManager.dispose();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Check purchase state before anything else
  await updateNoAdsState();

  final data = await ApiService.fetchAppData();
  print('API Response: $data');

  if (data != null) {
    if (data.rewardedFull.isNotEmpty) {
      print('Setting privacy policy: ${data.rewardedFull}');
      Common.privacy_policy = data.rewardedFull;
    }
    if (data.rewardedFull2.isNotEmpty) {
      print('Setting terms and conditions: ${data.rewardedFull2}');
      Common.terms_conditions = data.rewardedFull2;
    }
    if (data.startAppFull.isNotEmpty) {
      print('Setting playstore link: ${data.startAppFull}');
      Common.playstore_link = data.startAppFull;
    }
    if (data.gamezopId.isNotEmpty) {
      print('qureka game layout: ${data.gamezopId}');
      Common.qureka_game_show = data.gamezopId;
    }
    if (data.rewardedFull1.isNotEmpty) {
      print('Ads Open Count: ${data.rewardedFull1}');
      Common.ads_open_count = data.rewardedFull1;
    }
    if (data.startAppRewarded.isNotEmpty) {
      print('Ads open area: ${data.startAppRewarded}');
      Common.adsopen = data.startAppRewarded;
    }

    if (data.qurekaId.isNotEmpty) {
      print('qureka link: ${data.qurekaId}');
      Common.Qurekaid = data.qurekaId;
      // Common.Qurekaid = "";
    }

    if (data.admobId.isNotEmpty) {
      print('Setting banner ad ID: ${data.admobId}');
      Common.bannar_ad_id = data.admobId;
    }
    if (data.admobFull.isNotEmpty) {
      print('Setting interstitial ad ID: ${data.admobFull}');
      Common.interstitial_ad_id = data.admobFull;
    }
    if (data.admobFull1.isNotEmpty) {
      print('Setting interstitial ad ID1: ${data.admobFull1}');
      Common.interstitial_ad_id1 = data.admobFull1;
    }
    if (data.admobFull2.isNotEmpty) {
      print('Setting interstitial ad ID2: ${data.admobFull2}');
      Common.interstitial_ad_id2 = data.admobFull2;
    }
    if (data.admobNative.isNotEmpty) {
      print('Setting native ad ID: ${data.admobNative}');
      Common.native_ad_id = data.admobNative;
    }
    if (data.rewardedInt.isNotEmpty) {
      print('Setting app open ad ID: ${data.rewardedInt}');
      Common.app_open_ad_id = data.rewardedInt;
    }
  }

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();

  // Initialize AppLifecycleReactor
  final appLifecycleReactor = AppLifecycleReactor(
    appOpenAdManager: appOpenAdManager,
  );
  appLifecycleReactor.listenToAppStateChanges();

  // Preload the app open ad
  await appOpenAdManager.loadAd();

  return runApp(
    ChangeNotifierProvider(
      create: (_) => LudoProvider()..startGame(playerCount: 4),
      child: const Root(),
    ),
  );
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    ///Initialize images and precache it
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        precacheImage(const AssetImage("assets/images/splash.png"), context),
        precacheImage(const AssetImage("assets/images/thankyou.gif"), context),
        precacheImage(const AssetImage("assets/images/board.png"), context),
        precacheImage(const AssetImage("assets/images/dice/1.png"), context),
        precacheImage(const AssetImage("assets/images/dice/2.png"), context),
        precacheImage(const AssetImage("assets/images/dice/3.png"), context),
        precacheImage(const AssetImage("assets/images/dice/4.png"), context),
        precacheImage(const AssetImage("assets/images/dice/5.png"), context),
        precacheImage(const AssetImage("assets/images/dice/6.png"), context),
        precacheImage(const AssetImage("assets/images/dice/draw.gif"), context),
        precacheImage(const AssetImage("assets/images/crown/1st.png"), context),
        precacheImage(const AssetImage("assets/images/crown/2nd.png"), context),
        precacheImage(const AssetImage("assets/images/crown/3rd.png"), context),
        precacheImage(const AssetImage("assets/images/bannerads.png"), context),
        precacheImage(const AssetImage("assets/images/letsgo.png"), context),
        precacheImage(const AssetImage("assets/images/qurekaads.png"), context),
        precacheImage(
          const AssetImage("assets/images/qurekaads2.png"),
          context,
        ),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics), // ✅ track navigation
      ],
      home: const SplashScreen(),
    );
  }
}
