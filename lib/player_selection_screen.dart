import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludomaster/player_description.dart';
import 'package:ludomaster/privacy_policy_screen.dart';
import 'package:ludomaster/share_service.dart';

import 'Utils/common.dart';
import 'feedback_service.dart';
import 'game/game_screen.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen>
    with TickerProviderStateMixin {
  int selectedPlayers = 2;
  late String selectedDescription =
      "Enjoy a classic head-to-head challenge in Ludo with the 2-player mode. This mode is perfect when you want a quick and exciting match with just one friend. Test your strategy, make smart moves, and race your tokens to the finish line before your opponent. Every dice roll counts—one mistake can cost you the game! Whether online or offline, 2-player mode gives you the thrill of intense one-on-one competition.";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (Common.adsopen == "1" || Common.adsopen == "2") {
      Common.openUrl();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerDescriptionScreen(
          playerCount: selectedPlayers,
          selectedDescription: selectedDescription,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
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
                          Common.Qurekaid.isNotEmpty
                              ? const InkWell(
                            onTap: Common.openUrl,
                            child: Image(
                              image: AssetImage(
                                "assets/images/qurekaads3.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image(
                            image: AssetImage("assets/images/j1.png"),
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          // Subtitle
                          const Text(
                            'Select Number of Players',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Common.qureka_game_show.isNotEmpty
                              ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (Common.adsopen == "1" ||
                                      Common.adsopen == "2") {
                                    Common.openUrl();
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const GameScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E3A8A),
                                        Color(0xFF3B82F6),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.games,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Browse Game Categories',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                              : SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildPlayerCard(
                                  2,
                                  '2 Players',
                                  'Head to Head',
                                ),
                                const SizedBox(height: 10),
                                _buildPlayerCard(
                                  3,
                                  '3 Players',
                                  'Three Way Battle',
                                ),
                                const SizedBox(height: 10),
                                _buildPlayerCard(4, '4 Players', 'Full House'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(height: 1, color: Colors.black54),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _startGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1ab826),
                                  foregroundColor: const Color(0xFF1E3A8A),
                                  elevation: 8,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'START GAME',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
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
        ),
      ),
    );
  }

  Widget _buildPlayerCard(int players, String title, String subtitle) {
    final isSelected = selectedPlayers == players;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlayers = players;
          if (players == 2)
            selectedDescription =
            "Enjoy a classic head-to-head challenge in Ludo with the 2-player mode. This mode is perfect when you want a quick and exciting match with just one friend. Test your strategy, make smart moves, and race your tokens to the finish line before your opponent. Every dice roll counts—one mistake can cost you the game! Whether online or offline, 2-player mode gives you the thrill of intense one-on-one competition.";
          if (players == 3)
            selectedDescription =
            "Want something more exciting than a 1v1 but not as crowded as 4 players? The 3-player mode is just right for you. In this mode, three players battle it out on the Ludo board with equal chances of winning. Play smart, block your opponents, and don’t let them reach the home first. This mode brings a perfect balance of fun, strategy, and challenge—ideal for when you have two friends ready to roll the dice!";
          if (players == 4)
            selectedDescription =
            "Experience the ultimate Ludo fun with the 4-player mode! This is the most popular and classic way to enjoy Ludo with friends and family. Up to four players can join the board, making the game full of excitement, twists, and surprises. Team up or play solo, block your opponents, and race your tokens to victory. The 4-player mode guarantees laughter, fun, and endless entertainment—perfect for parties, gatherings, or family game nights.";
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.black.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ]
              : null,
        ),
        child: Column(
          children: [
            // Player icons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPlayerIcon(Colors.green, players >= 1),
                const SizedBox(width: 2),
                _buildPlayerIcon(Colors.yellow, players >= 2),
                const SizedBox(width: 2),
                _buildPlayerIcon(Colors.red, players >= 3),
                const SizedBox(width: 2),
                _buildPlayerIcon(Colors.blue, players >= 4),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 5),
            // Text content
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       subtitle,
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: isSelected ? Colors.black : Colors.white,
            //         fontWeight: FontWeight.bold
            //       ),
            //     ),
            //     // Check icon
            //     if (isSelected)
            //       const Icon(
            //         Icons.check_circle,
            //         color: Color(0xFF1E3A8A),
            //         size: 30,
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerIcon(Color color, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: isActive
          ? const Icon(Icons.person, color: Colors.white, size: 18)
          : null,
    );
  }
}
