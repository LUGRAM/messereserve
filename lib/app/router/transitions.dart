import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Transition custom pour les pages Messe
CustomTransitionPage<T> massTransition<T>({
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    child: child,

    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      // Fade principal
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      // Slide subtil lors du retour
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.05), // léger décalage vertical
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}
