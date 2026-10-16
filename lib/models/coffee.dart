class Coffee {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> tags;
  bool isFavorite;

  Coffee({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.tags,
    this.isFavorite = false,
  });
}

final List<Coffee> coffees = [
  Coffee(
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
