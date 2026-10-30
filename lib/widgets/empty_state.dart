import 'package:flutter/material.dart';

/// Placeholder shown when every item was dismissed.
class EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyState({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Catalog is Empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You removed every coffee. Restore the initial catalog to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restore),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
