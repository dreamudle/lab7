import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'screens/root_screen.dart';

void main() {
  runApp(const CoffeeApp());
}

/// By default Flutter Web does not scroll or pull-to-refresh with a mouse
/// drag. This lets mouse / trackpad / stylus drag lists like a finger would,
/// so pull-to-refresh and swipe-to-delete can be tried in a desktop browser.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const RootScreen(),
    );
  }
}