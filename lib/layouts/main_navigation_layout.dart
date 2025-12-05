import 'package:flutter/material.dart';
import 'package:messeconnect/features/navigation/main_navigation.dart';

class MainNavigationLayout extends StatelessWidget {
  final Widget child;

  const MainNavigationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      content: child,
    );
  }
}
