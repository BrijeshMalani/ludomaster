import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Utils/common.dart';
import '../models/game_data_model.dart';
import '../services/app_open_ad_manager.dart';
import '../services/game_service.dart';
import '../widgets/native_banner_ad_widget.dart';
import 'games_list_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameDataResponse? _gameData;
  List<String> _categories = [];
  bool _isLoading = true;
  String? _error;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd(Common.interstitial_ad_id);
    _loadInterstitialAd(Common.interstitial_ad_id1);
    _loadInterstitialAd(Common.interstitial_ad_id2);

    _loadGames();
  }

  void _loadInterstitialAd(String ads_id) {
    InterstitialAd.load(
      adUnitId: ads_id,
      // Android test interstitial ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd(VoidCallback onAdClosed, String ads_id) {
    if (_interstitialAd != null) {
      // Prevent app open ad on the next resume caused by interstitial
      AppOpenAdManager.suppressNextOnResume();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd(ads_id);
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd(ads_id);
          onAdClosed();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onAdClosed();
    }
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameData = await GameService.fetchGames(id: '10787');

      if (gameData != null) {
        setState(() {
          _gameData = gameData;
          _categories = GameService.getUniqueCategories(gameData.games);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load games';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadGames,
          ),
        ],
      ),
      body: Container(color: Color(0xFFF5F5F5), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading games...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGames,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Text(
          'No categories found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with game count
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.games, color: Colors.black, size: 24),
              const SizedBox(width: 8),
              Text(
                '${_gameData?.games.length ?? 0} Games Available',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Categories list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final gamesInCategory = GameService.getGamesByCategory(
                _gameData!.games,
                category,
              );

              return _buildCategoryCard(context, category, gamesInCategory);
            },
          ),
        ),
        Stack(
          children: [
            Common.Qurekaid.isNotEmpty
                ? InkWell(
                    onTap: Common.openUrl,
                    child: Image(
                      width: MediaQuery.of(context).size.width,
                      image: const AssetImage("assets/images/bannerads.png"),
                      fit: BoxFit.fill,
                    ),
                  )
                : SizedBox(),
            Common.native_ad_id.isNotEmpty
                ? NativeBannerAdWidget()
                : SizedBox(),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    final category,
    List<Game> games,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          if (Common.adsopen == "1") {
            Common.openUrl();
          }
          Common.interstitial_ad_id1.isEmpty
              ? Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GamesListScreen(category: category, games: games),
                  ),
                )
              : _showInterstitialAd(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GamesListScreen(category: category, games: games),
                    ),
                  );
                }, Common.interstitial_ad_id1);
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.green,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Category info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${games.length} games available',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Sample game names
                    if (games.isNotEmpty) ...[
                      Text(
                        'Sample: ${games.take(3).map((g) => g.name.en).join(', ')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'action':
        return Icons.flash_on;
      case 'strategy':
        return Icons.psychology;
      case 'puzzle & logic':
      case 'puzzle':
        return Icons.extension;
      case 'arcade':
        return Icons.games;
      case 'sports & racing':
      case 'sports':
        return Icons.sports_soccer;
      case 'adventure':
        return Icons.explore;
      case 'featured':
        return Icons.star;
      default:
        return Icons.games;
    }
  }
}
