import 'dart:math';

class Coffee {
  /// Unique id. Used as `ValueKey(coffee.id)` in Dismissible, so Flutter can
  /// tell exactly which row was removed (names may repeat, ids never do).
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> tags;
  bool isFavorite;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.tags,
    this.isFavorite = false,
  });

  /// Category label shown as a small tag (the first tag of the coffee).
  String get category => tags.isEmpty ? 'Coffee' : tags.first;
}

/// Initial seed data. Returns fresh objects every call, so "Reset Catalog"
/// brings back the original catalog (without favorites).
List<Coffee> buildSeedCoffees() => [
  Coffee(
    id: 1,
    name: 'Brasil (Sul de Minas)',
    description:
        'Sweet caramel melts into warm roasted nuts in every sip. '
        'A perfectly balanced cup, smooth from the first taste to the last.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=1',
    price: 1.5,
    rating: 4.8,
    tags: ['Caramel', 'Nutty', 'Balanced'],
  ),
  Coffee(
    id: 2,
    name: 'Brasil (Mantiqueira)',
    description:
        'A bright, fresh cup with delicate flower aroma and a juicy '
        'citrus spark. Finishes clean with a light, sweet aftertaste.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=2',
    price: 1.8,
    rating: 4.6,
    tags: ['Floral', 'Citrus', 'Sweet'],
  ),
  Coffee(
    id: 3,
    name: 'Brasil (Mogiana)',
    description:
        'Like a cup of melted milk chocolate: silky, creamy and gently '
        'sweet. A cozy, full-bodied coffee that feels like a dessert.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=3',
    price: 1.2,
    rating: 4.5,
    tags: ['Milk Chocolate', 'Creamy', 'Sweet'],
  ),
  Coffee(
    id: 4,
    name: 'Brasil (Cerrado Mineiro)',
    description:
        'Rich dark chocolate and toasted hazelnut in a soft, mellow cup. '
        'Low acidity makes it easy and comforting to enjoy any time of day.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=4',
    price: 1.6,
    rating: 4.3,
    tags: ['Chocolate', 'Hazelnut', 'Low Acidity'],
  ),
  Coffee(
    id: 5,
    name: 'Brasil (Espírito Santo)',
    description:
        'Bold and powerful with a deep earthy character and a pleasant '
        'bitter edge. A strong, full-bodied cup for true coffee lovers.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=5',
    price: 2.2,
    rating: 4.9,
    tags: ['Earthy', 'Bold', 'Bitter'],
  ),
];

/// The app's catalog. It is mutable: pull-to-refresh inserts new items,
/// swipe-to-delete removes them, "Reset Catalog" restores the seed data.
final List<Coffee> coffees = buildSeedCoffees();

/// Restores the initial seed data (used by the empty state button).
void resetCoffees() {
  coffees
    ..clear()
    ..addAll(buildSeedCoffees());
}

// ---------------------------------------------------------------------------
// Generator for "new arrivals" (simulated server response on pull-to-refresh)
// ---------------------------------------------------------------------------

final Random _random = Random();

/// Seed ids are 1..5, generated items start from 100 and are always unique.
int _nextId = 100;

const List<String> _origins = [
  'Colombia (Huila)',
  'Ethiopia (Yirgacheffe)',
  'Kenya (Nyeri)',
  'Guatemala (Antigua)',
  'Costa Rica (Tarrazú)',
  'Rwanda (Kivu)',
  'Peru (Cajamarca)',
  'Honduras (Marcala)',
];

const List<String> _tagPool = [
  'Fruity',
  'Berry',
  'Winey',
  'Honey',
  'Spicy',
  'Cocoa',
  'Almond',
  'Smooth',
  'Bright',
  'Juicy',
];

/// Creates a new random coffee with a unique id.
Coffee generateCoffee() {
  final id = _nextId++;
  final tags = (List<String>.of(_tagPool)..shuffle(_random)).take(3).toList();

  return Coffee(
    id: id,
    name: _origins[_random.nextInt(_origins.length)],
    description:
        'A fresh new arrival from our roastery. '
        'Notes of ${tags[0].toLowerCase()}, ${tags[1].toLowerCase()} '
        'and ${tags[2].toLowerCase()} in a clean, memorable cup.',
    imageUrl: 'https://loremflickr.com/600/400/coffee?lock=$id',
    price: (100 + _random.nextInt(151)) / 100, // 1.00 .. 2.50
    rating: (40 + _random.nextInt(11)) / 10, // 4.0 .. 5.0
    tags: tags,
  );
}