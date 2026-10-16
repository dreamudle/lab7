import 'package:flutter/material.dart';

import '../models/coffee.dart';
import '../widgets/coffee_card.dart';
import 'detail_screen.dart';

/// Tab 2: saved items.
class FavoritesScreen extends StatelessWidget {
  /// Called after favorites change so the other tabs can refresh.
  final VoidCallback onChanged;

  const FavoritesScreen({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final favorites = coffees.where((c) => c.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 72, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the heart on any coffee in the Feed to save it here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final coffee in favorites)
                  CoffeeCard(
                    coffee: coffee,
                    onFavorite: () {
                      coffee.isFavorite = !coffee.isFavorite;
                      onChanged();
                    },
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(coffee: coffee),
                        ),
                      );
                      onChanged();
                    },
                  ),
              ],
            ),
    );
  }
}
