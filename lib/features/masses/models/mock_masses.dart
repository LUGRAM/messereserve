import 'package:flutter/material.dart';
import 'mass_model.dart';

final List<MassModel> mockMasses = [
  MassModel(
    id: "requiem",
    title: "Messe de Requiem",
    subtitle: "Pour les défunts",
    imageAsset: "assets/images/masses/requiem.jpg",
    heroTag: "messe_requiem",
    accentColor: const Color(0xFF42A5F5),
    lottieAsset: "assets/lottie/candle.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "action-grace",
    title: "Messe d’Action de Grâce",
    subtitle: "Remerciement à Dieu",
    imageAsset: "assets/images/masses/action_grace.jpg",
    heroTag: "messe_action_grace",
    accentColor: const Color(0xFFEF5350),
    lottieAsset: "assets/lottie/thanks.json",
    requiresBeneficiary: false,
  ),

  MassModel(
    id: "guerison",
    title: "Messe pour la Santé",
    subtitle: "Guérison & réconfort",
    imageAsset: "assets/images/masses/guerison.jpg",
    heroTag: "messe_guerison",
    accentColor: const Color(0xFF66BB6A),
    lottieAsset: "assets/lottie/health.json",
    requiresBeneficiary: false,
  ),

  MassModel(
    id: "nuptiale",
    title: "Messe Nuptiale",
    subtitle: "Union sacrée",
    imageAsset: "assets/images/masses/nuptial.jpg",
    heroTag: "messe_nuptiale",
    accentColor: const Color(0xFF5C6BC0),
    lottieAsset: "assets/lottie/wedding.json",
    requiresBeneficiary: false,
  ),

];