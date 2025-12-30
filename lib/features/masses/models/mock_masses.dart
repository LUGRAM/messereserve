import 'package:flutter/material.dart';
import 'mass_model.dart';

final List<MassModel> mockMasses = [
  MassModel(
    id: "requiem",
    title: "Messe de Requiem",
    amount: "2000",
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
    amount: "2000",
    subtitle: "Remerciement à Dieu",
    imageAsset: "assets/images/masses/action_grace.jpg",
    heroTag: "messe_action_grace",
    accentColor: const Color(0xFFEF5350),
    lottieAsset: "assets/lottie/thanks.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "guerison",
    title: "Messe pour la Santé",
    amount: "2000",
    subtitle: "Guérison & réconfort",
    imageAsset: "assets/images/masses/guerison.jpg",
    heroTag: "messe_guerison",
    accentColor: const Color(0xFF66BB6A),
    lottieAsset: "assets/lottie/healing.json",
    requiresBeneficiary: true,
  ),

  MassModel(
    id: "nuptiale",
    title: "Messe Nuptiale",
    amount: "2000",
    subtitle: "Union sacrée",
    imageAsset: "assets/images/masses/nuptial.jpg",
    heroTag: "messe_nuptiale",
    accentColor: const Color(0xFFFFFFFF),
    lottieAsset: "assets/lottie/rings.json",
    requiresBeneficiary: true,
  ),

];