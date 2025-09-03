import 'package:flutter/material.dart';
import '../Utils/common.dart';
import '../models/game_data_model.dart';
import 'game_description_screen.dart';

class GamesListScreen extends StatelessWidget {
  final String category;
  final List<Game> games;

  const GamesListScreen({
    super.key,
    required this.category,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Games'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
              child: games.isEmpty
                  ? const Center(
                      child: Text(
                        'No games found in this category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _getTotalItemCount(),
                      itemBuilder: (context, index) {
                        return _buildItem(context, index);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Game game) {
    return Card(
      elevation: 8,
      color: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          if (Common.adsopen == "1") {
            Common.openUrl();
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDescriptionScreen(game: game),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Cover Image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(game.assets.cover),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: Stack(
                  children: [
                    // Rating overlay
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              game.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Game Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game Name
                    Text(
                      game.name.en,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Game Plays
                    Text(
                      '${_formatNumber(game.gamePlays)} plays',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    // Categories
                    // Wrap(
                    //   spacing: 4,
                    //   children: game.categories.en.take(2).map((category) {
                    //     return Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 6,
                    //         vertical: 2,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: Text(
                    //         category,
                    //         style: const TextStyle(
                    //           fontSize: 10,
                    //           color: Color(0xFF1E3A8A),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  int _getTotalItemCount() {
    // If no ad ID, just show games
    if (Common.Qurekaid.isEmpty) {
      return games.length;
    }

    // Pattern: Ad row (1 item) + 4 games + Ad row (1 item) + 4 games...
    // Every 5 items: 1 ad + 4 games
    int totalSections = (games.length / 4).ceil();
    return totalSections * 5; // 5 items per section (1 ad + 4 games)
  }

  Widget _buildItem(BuildContext context, int index) {
    // If no ad ID, just show games
    if (Common.Qurekaid.isEmpty) {
      if (index < games.length) {
        return _buildGameCard(context, games[index]);
      }
      return Container();
    }

    // Calculate which section we're in
    int sectionIndex = index ~/ 5; // 5 items per section
    int positionInSection = index % 5;

    // Position 0 in each section is an ad
    if (positionInSection == 0) {
      return _buildAdCard(context);
    }

    // Positions 1, 2, 3, 4 are games
    int gameIndex = sectionIndex * 4 + (positionInSection - 1);
    if (gameIndex < games.length) {
      return _buildGameCard(context, games[gameIndex]);
    }

    // Fallback empty container
    return Container();
  }

  Widget _buildAdCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: Common.openUrl,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/images/adshalf.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
