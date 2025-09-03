import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ludomaster/player_selection_screen.dart';
import 'package:ludomaster/privacy_policy_screen.dart';
import 'package:ludomaster/share_service.dart';
import 'package:ludomaster/services/app_open_ad_manager.dart';
import 'package:ludomaster/widgets/native_ad_banner_widget.dart';
import 'package:ludomaster/widgets/native_ad_widget.dart';

import 'Utils/common.dart';
import 'feedback_service.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
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
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF5F5F5),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 56,
                  color: Colors.yellow,
                  child: Row(
                    children: [
                      const Spacer(),
                      const Text(
                        'Crazy Ludo',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          _showMenuPopup(context);
                        },
                        child: const Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Common.Qurekaid.isNotEmpty
                                ? InkWell(
                                    onTap: Common.openUrl,
                                    child: Image(
                                      image: AssetImage(
                                        "assets/images/qurekaads.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image(
                                    image: AssetImage("assets/images/j1.png"),
                                    fit: BoxFit.cover,
                                  ),

                            Common.native_ad_id.isNotEmpty
                                ? NativeAdWidget()
                                : Image(
                                    image: AssetImage("assets/images/j1.png"),
                                    fit: BoxFit.cover,
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (Common.Qurekaid.isNotEmpty)
                          InkWell(
                            onTap: () {
                              Common.openUrl();
                            },
                            child: const Image(
                              height: 70,
                              image: AssetImage("assets/images/letsgo.png"),
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Common.adsopen == "1" ||
                                    Common.adsopen == "2") {
                                  Common.openUrl();
                                }
                                Common.interstitial_ad_id.isEmpty
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlayerSelectionScreen(),
                                        ),
                                      )
                                    : _showInterstitialAd(() {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PlayerSelectionScreen(),
                                          ),
                                        );
                                      });
                              },
                              child: Image(
                                height:
                                    MediaQuery.of(context).size.width / 2 - 10,
                                image: const AssetImage("assets/images/l1.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (Common.adsopen == "2") {
                                  Common.openUrl();
                                }
                                FeedbackService.openPlayStoreFeedback();
                              },
                              child: Image(
                                height:
                                    MediaQuery.of(context).size.width / 2 - 10,
                                image: const AssetImage("assets/images/l2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Common.Qurekaid.isNotEmpty
                            ? Column(
                                children: [
                                  const InkWell(
                                    onTap: Common.openUrl,
                                    child: Image(
                                      image: AssetImage(
                                        "assets/images/qurekaads2.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              )
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Common.adsopen == "1" ||
                                    Common.adsopen == "2") {
                                  Common.openUrl();
                                }
                                ShareService.shareAppOnSocialMedia();
                              },
                              child: Image(
                                height:
                                    MediaQuery.of(context).size.width / 2 - 10,
                                image: const AssetImage("assets/images/l3.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (Common.adsopen == "2") {
                                  Common.openUrl();
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                              child: Image(
                                height:
                                    MediaQuery.of(context).size.width / 2 - 10,
                                image: const AssetImage("assets/images/l4.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Common.Qurekaid.isNotEmpty
                        ? InkWell(
                            onTap: Common.openUrl,
                            child: Image(
                              width: MediaQuery.of(context).size.width,
                              image: const AssetImage(
                                "assets/images/bannerads.png",
                              ),
                              fit: BoxFit.fill,
                            ),
                          )
                        : SizedBox(),
                    Common.native_ad_id.isNotEmpty
                        ? NativeAdBannerWidget()
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exit Icon
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title
                          const Text(
                            'Exit App',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Message
                          const Text(
                            'Are you sure you want to exit the app?',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Common.Qurekaid.isNotEmpty
                        ? Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Common.Qurekaid.isNotEmpty
                                ? InkWell(
                                    onTap: Common.openUrl,
                                    child: Image(
                                      width: MediaQuery.of(context).size.width,
                                      image: const AssetImage(
                                        "assets/images/bannerads.png",
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : SizedBox(),
                          )
                        : SizedBox(),
                    // Buttons
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // No Button
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(false); // No - don't exit
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Yes Button
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.red, Colors.redAccent],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // Yes - exit
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  void _showMenuPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Menu Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu Items
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Rate Us
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.star,
                        title: 'Rate Us',
                        subtitle: 'Rate our app on Play Store',
                        onTap: () {
                          Navigator.of(context).pop();
                          FeedbackService.openPlayStoreFeedback();
                        },
                      ),
                      const SizedBox(height: 10),
                      // Share
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.share,
                        title: 'Share',
                        subtitle: 'Share app with friends',
                        onTap: () {
                          Navigator.of(context).pop();
                          ShareService.shareAppOnSocialMedia();
                        },
                      ),
                      const SizedBox(height: 10),
                      // Privacy Policy
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        subtitle: 'View our privacy policy',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Exit
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.exit_to_app,
                        title: 'Exit',
                        subtitle: 'Close the application',
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Exit App'),
                                content: const Text(
                                  'Are you sure you want to exit?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('Exit'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}
