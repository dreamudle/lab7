import 'package:flutter/material.dart';

import '../models/coffee.dart';
import 'category_tag.dart';
import 'star_rating.dart';

/// One row of the List Feed: avatar icon, title, category tag, stars, price.
class CoffeeListTile extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CoffeeListTile({
    super.key,
    required this.coffee,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // Opaque background: it hides the red "delete" layer of Dismissible
      // until the row is actually swiped.
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.brown.shade300,
                child: const Icon(Icons.coffee, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Wrap (not Row): on narrow screens the stars simply
                    // move to the next line instead of overflowing.
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CategoryTag(label: coffee.category),
                        StarRating(rating: coffee.rating),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${coffee.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  coffee.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: coffee.isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}