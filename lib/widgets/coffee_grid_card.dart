import 'package:flutter/material.dart';

import '../models/coffee.dart';
import 'category_tag.dart';
import 'coffee_image.dart';
import 'star_rating.dart';

/// One card of the Grid Catalog (2 columns, childAspectRatio 0.72).
///
/// The image is wrapped in Expanded: it takes whatever height is left after
/// the text block, so the card can never overflow its grid cell.
class CoffeeGridCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  /// Corner radius shared with the red delete background of Dismissible.
  static const double radius = 12;

  const CoffeeGridCard({
    super.key,
    required this.coffee,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoffeeImage(url: coffee.imageUrl, iconSize: 48),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            coffee.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: coffee.isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CategoryTag(label: coffee.category),
                  const SizedBox(height: 6),
                  StarRating(rating: coffee.rating, size: 14),
                  const SizedBox(height: 6),
                  Text(
                    '\$${coffee.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}