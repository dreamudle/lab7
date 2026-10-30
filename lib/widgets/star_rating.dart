import 'package:flutter/material.dart';

/// Five stars (full / half / empty) followed by the numeric rating.
class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 16});

  IconData _iconFor(int star, double rounded) {
    if (rounded >= star) return Icons.star;
    if (rounded >= star - 0.5) return Icons.star_half;
    return Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    // Round to the nearest half star: 4.8 -> 5.0, 4.3 -> 4.5.
    final rounded = (rating * 2).round() / 2;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= 5; star++)
          Icon(_iconFor(star, rounded), color: Colors.amber, size: size),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size - 2),
        ),
      ],
    );
  }
}