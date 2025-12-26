// lib/layouts/mass_layout.dart
import 'package:flutter/material.dart';

class MassLayout extends StatelessWidget {
  final Widget child;

  const MassLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false, //
      body: SafeArea(
        top: false,   
        bottom: false,
        child: child,
      ),
    );
  }
}
