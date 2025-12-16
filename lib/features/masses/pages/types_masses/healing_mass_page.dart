// lib/features/masses/pages/healing_mass_page.dart

import 'package:flutter/material.dart';
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';

class HealingMassPage extends StatelessWidget {
  const HealingMassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MassDetailBasePage(
      heroTag: 'messe_guerison',
      imageAsset: 'assets/images/masses/guerison.jpg',
      title: 'Messe pour la Santé',
      subtitle: 'Confiez à Dieu vos maladies, vos traitements et vos proches.',
      accentColor: Colors.green,
      massTitle: 'Messe pour la Santé et la Guérison',
      requiresBeneficiary: false,
      lottieAsset: 'assets/lottie/healing.json',

    );
  }
}
