import 'package:flutter/material.dart';

import '../models/coffee.dart';
import '../widgets/coffee_card.dart';
import 'detail_screen.dart';

/// Tab 1: Feed (with search and tag filter).
class HomeScreen extends StatefulWidget {
  /// Called after favorites change so the other tabs can refresh.
  final VoidCallback onChanged;

  const HomeScreen({super.key, required this.onChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String? _selectedTag; // null = "All"

  @override
  Widget build(BuildContext context) {
    final favCount = coffees.where((c) => c.isFavorite).length;

    // All unique tags from all coffees, for the filter chips.
    final allTags = <String>{
      for (final c in coffees) ...c.tags,
    }.toList()
      ..sort();

    // Apply search + tag filter.
    final visible = coffees.where((c) {
      final matchesName =
          c.name.toLowerCase().contains(_query.trim().toLowerCase());
      final matchesTag = _selectedTag == null || c.tags.contains(_selectedTag);
      return matchesName && matchesTag;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Favorites: $favCount')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose your coffee',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Search field
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search coffee...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tag filter chips
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedTag == null,
                onSelected: (_) => setState(() => _selectedTag = null),
              ),
              for (final tag in allTags)
                ChoiceChip(
                  label: Text(tag),
                  selected: _selectedTag == tag,
                  onSelected: (_) => setState(
                    () => _selectedTag = _selectedTag == tag ? null : tag,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('Nothing found')),
            ),

          for (final coffee in visible)
            CoffeeCard(
              coffee: coffee,
              onFavorite: () {
                setState(() {
                  coffee.isFavorite = !coffee.isFavorite;
                });
                widget.onChanged();
              },
              onTap: () async {
                // Navigator.push: the whole Coffee object goes to DetailScreen
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(coffee: coffee),
                  ),
                );
                // Back from DetailScreen: refresh without restarting anything
                setState(() {});
                widget.onChanged();
              },
            ),
        ],
      ),
    );
  }
}