import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final int favoritesCount;

  const ProfileScreen({super.key, required this.favoritesCount});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _orderUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.brown.shade200,
              child: const Icon(Icons.person, size: 56, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Michael Jackson', 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text('Qgrader')),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Saved coffees'),
            trailing: Text(
              '${widget.favoritesCount}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.local_cafe),
            title: const Text('Order updates'),
            value: _orderUpdates,
            onChanged: (value) => setState(() => _orderUpdates = value),
          ),
        ],
      ),
    );
  }
}
