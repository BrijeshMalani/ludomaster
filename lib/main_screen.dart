import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludomaster/privacy_policy_screen.dart';
import 'package:ludomaster/share_service.dart';
import 'package:ludomaster/widgets/board_widget.dart';
import 'package:ludomaster/widgets/dice_widget.dart';
import 'package:provider/provider.dart';

import 'Utils/common.dart';
import 'constants.dart';
import 'feedback_service.dart';
import 'ludo_provider.dart';

class MainScreen extends StatefulWidget {
  final int playerCount;
  const MainScreen({super.key, this.playerCount = 4});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Start the game with the selected player count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LudoProvider>().startGame(playerCount: widget.playerCount);
    });
  }

  // Function to get dice position in screen corners based on current player
  Map<String, double?> getDicePositionInCorners(LudoPlayerType currentPlayer) {
    switch (currentPlayer) {
      case LudoPlayerType.green:
        return {
          'left': 20, // Top-left corner
          'top': 50, // Higher up, closer to status bar
          'right': null,
          'bottom': null,
        };
      case LudoPlayerType.yellow:
        return {
          'left': null,
          'top': 50, // Higher up, closer to status bar
          'right': 20, // Top-right corner
          'bottom': null,
        };
      case LudoPlayerType.blue:
        return {
          'left': null,
          'top': null,
          'right': 20, // Bottom-right corner
          'bottom': 50, // Higher up from bottom
        };
      case LudoPlayerType.red:
        return {
          'left': 20, // Bottom-left corner
          'top': null,
          'right': null,
          'bottom': 50, // Higher up from bottom
        };
      default:
        return {
          'left': 20,
          'top': 50,
          'right': null,
          'bottom': null,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.green,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BoardWidget(),
                        ],
                      ),
                    ),
                    // Dice positioned in screen corners based on current player
                    Consumer<LudoProvider>(
                      builder: (context, provider, child) {
                        Map<String, double?> position =
                            getDicePositionInCorners(provider.currentPlayer.type);

                        return Positioned(
                          left: position['left'],
                          right: position['right'],
                          top: position['top'],
                          bottom: position['bottom'],
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const DiceWidget(),
                          ),
                        );
                      },
                    ),
                    Consumer<LudoProvider>(
                      builder: (context, value, child) => value.winners.length == 3
                          ? Container(
                              color: Colors.black.withOpacity(0.8),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset("assets/images/thankyou.gif"),
                                    const Text("Thank you for playing 😙",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        textAlign: TextAlign.center),
                                    Text(
                                        "The Winners is: ${value.winners.map((e) => e.name.toUpperCase()).join(", ")}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 30),
                                        textAlign: TextAlign.center),
                                    const Divider(color: Colors.white),
                                    const Text(
                                        "This game made with Flutter ❤️ by Mochamad Nizwar Syafuan",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 20),
                                    const Text("Refresh your browser to play again",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
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
