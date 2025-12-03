// lib/layouts/home_layout.dart

import 'package:flutter/material.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';

class HomeLayout extends StatelessWidget {
  final Widget child;

  const HomeLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: child),
      ),
    );
  }
}
