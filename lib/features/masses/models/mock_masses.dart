import 'package:flutter/material.dart';
import 'mass_model.dart';

final List<MassModel> mockMasses = [
  MassModel(
    id: "requiem",
    title: "Messe de Requiem",
    subtitle: "Pour les défunts",
    imageAsset: "assets/images/masses/requiem.jpg",
    heroTag: "messe_requiem",
    accentColor: const Color(0xFF91A8D0),
    lottieAsset: "assets/lottie/candle.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "action-grace",
    title: "Messe d’Action de Grâce",
    subtitle: "Remerciement à Dieu",
    imageAsset: "assets/images/masses/action_grace.jpg",
    heroTag: "messe_action_grace",
    accentColor: const Color(0xFFF98B88),
    lottieAsset: "assets/lottie/thanks.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "guerison",
    title: "Messe pour la Santé",
    subtitle: "Guérison & réconfort",
    imageAsset: "assets/images/masses/guerison.jpg",
    heroTag: "messe_guerison",
    accentColor: const Color(0xFF89F336),
    lottieAsset: "assets/lottie/healing.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "nuptiale",
    title: "Messe Nuptiale",
    subtitle: "Union sacrée",
    imageAsset: "assets/images/masses/nuptial.jpg",
    heroTag: "messe_nuptiale",
    accentColor: const Color(0xFFEFBF04),
    lottieAsset: "assets/lottie/rings.json",
    requiresBeneficiary: true,
  ),

];