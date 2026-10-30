import 'package:flutter/material.dart';

import '../models/coffee.dart';
import '../widgets/coffee_grid_card.dart';
import '../widgets/coffee_list_tile.dart';
import '../widgets/dismissible_coffee.dart';
import '../widgets/empty_state.dart';
import 'detail_screen.dart';

/// Tab 1: Smart Catalog (list / grid, search, tag filter, pull-to-refresh,
/// swipe-to-delete with UNDO, empty state).
class HomeScreen extends StatefulWidget {
  /// Called after the catalog changes so the other tabs can refresh.
  final VoidCallback onChanged;

  const HomeScreen({super.key, required this.onChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();

  String _query = '';
  String? _selectedTag; // null = "All"
  bool _isGrid = false; // false = List Feed, true = Grid Catalog

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Actions
  // -------------------------------------------------------------------------

  /// Pull-to-Refresh: simulates a 1.5 s network request, then prepends a
  /// newly generated item to index 0.
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() {
      coffees.insert(0, generateCoffee());
      // A refresh reloads the whole catalog, so filters are cleared too:
      // the new item is guaranteed to be visible at the top.
      _query = '';
      _selectedTag = null;
      _searchController.clear();
    });
    widget.onChanged();
  }

  /// Swipe-to-Delete: remember the ORIGINAL index, remove the item and offer
  /// UNDO in a floating SnackBar.
  void _removeCoffee(Coffee coffee) {
    final index = coffees.indexOf(coffee);
    if (index == -1) return;

    setState(() => coffees.removeAt(index));
    widget.onChanged();

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // Newer Flutter keeps a SnackBar with an action on screen until it
          // is tapped; persist: false makes it auto-hide after the timeout.
          persist: false,
          content: Text('${coffee.name} removed'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (!mounted) return;
              // Put the item back exactly where it was.
              final at = index > coffees.length ? coffees.length : index;
              setState(() => coffees.insert(at, coffee));
              widget.onChanged();
            },
          ),
        ),
      );
  }

  /// Empty state button: restore the initial seed data.
  void _resetCatalog() {
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() {
      resetCoffees();
      _query = '';
      _selectedTag = null;
      _searchController.clear();
    });
    widget.onChanged();
  }

  void _toggleFavorite(Coffee coffee) {
    setState(() => coffee.isFavorite = !coffee.isFavorite);
    widget.onChanged();
  }

  Future<void> _openDetails(Coffee coffee) async {
    // Navigator.push: the whole Coffee object goes to DetailScreen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(coffee: coffee)),
    );
    // Back from DetailScreen: refresh without restarting anything
    if (!mounted) return;
    setState(() {});
    widget.onChanged();
  }

  // -------------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------------

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
          // Same refresh as the pull-down gesture. Handy in a desktop browser,
          // where pulling down with a mouse wheel / trackpad does not work.
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshKey.currentState?.show(),
          ),
          // Toggle: List Feed <-> Grid Catalog
          IconButton(
            tooltip: _isGrid ? 'Show list' : 'Show grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Favorites: $favCount')),
          ),
        ],
      ),
      // Limited width keeps the 2-column grid cards a sensible size on a
      // wide browser window.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              _buildHeader(allTags),
              Expanded(child: _buildContent(visible)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(List<String> allTags) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your coffee',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Search field
          TextField(
            controller: _searchController,
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

          // Tag filter chips: one horizontal row, so the header stays short
          // and the list below keeps most of the screen.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedTag == null,
                  onSelected: (_) => setState(() => _selectedTag = null),
                ),
                for (final tag in allTags)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(tag),
                      selected: _selectedTag == tag,
                      onSelected: (_) => setState(
                        () => _selectedTag = _selectedTag == tag ? null : tag,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<Coffee> visible) {
    // Catalog is completely empty -> placeholder with "Reset Catalog".
    if (coffees.isEmpty) {
      return EmptyState(onReset: _resetCatalog);
    }

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: visible.isEmpty
          ? _buildNothingFound()
          : (_isGrid ? _buildGrid(visible) : _buildList(visible)),
    );
  }

  /// Search / filter found nothing (the catalog itself is not empty).
  Widget _buildNothingFound() {
    return ListView(
      // AlwaysScrollable: pull-to-refresh also works with short content.
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: Text('Nothing found')),
        ),
      ],
    );
  }

  /// View mode 1: List Feed (lazy: only visible rows are built).
  Widget _buildList(List<Coffee> items) {
    return ListView.separated(
      // AlwaysScrollable: RefreshIndicator needs a scrollable even when
      // there are only a few rows.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final coffee = items[index];
        return DismissibleCoffee(
          coffee: coffee,
          onDismissed: () => _removeCoffee(coffee),
          child: CoffeeListTile(
            coffee: coffee,
            onTap: () => _openDetails(coffee),
            onFavorite: () => _toggleFavorite(coffee),
          ),
        );
      },
    );
  }

  /// View mode 2: Grid Catalog, 2 columns.
  Widget _buildGrid(List<Coffee> items) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // width / height of one cell: taller than wide, so the image,
        // text and price fit without a RenderFlex overflow.
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final coffee = items[index];
        return DismissibleCoffee(
          coffee: coffee,
          borderRadius: BorderRadius.circular(CoffeeGridCard.radius),
          onDismissed: () => _removeCoffee(coffee),
          child: CoffeeGridCard(
            coffee: coffee,
            onTap: () => _openDetails(coffee),
            onFavorite: () => _toggleFavorite(coffee),
          ),
        );
      },
    );
  }
}