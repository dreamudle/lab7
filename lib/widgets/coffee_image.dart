import 'package:flutter/material.dart';

class CoffeeImage extends StatelessWidget {
  final String url;
  final double iconSize;

  const CoffeeImage({super.key, required this.url, this.iconSize = 36});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Colors.brown.shade300,
      alignment: Alignment.center,
      child: Icon(Icons.coffee, size: iconSize, color: Colors.white),
    );

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
