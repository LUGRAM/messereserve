import 'package:flutter/material.dart';

class MassModel {
  final String id;

  // Affichage
  final String title;
  final String amount;
  final String subtitle;
  final String imageAsset;
  final String heroTag;

  // UI
  final Color accentColor;

  // Spécifique refactor
  final String lottieAsset;
  final bool requiresBeneficiary;

  const MassModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.imageAsset,
    required this.heroTag,
    required this.accentColor,
    required this.lottieAsset,
    required this.requiresBeneficiary,
  });
}
