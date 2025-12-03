import 'package:flutter/material.dart';
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';

class ThanksgivingMassPage extends StatelessWidget {
  const ThanksgivingMassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MassDetailBasePage(
      heroTag: 'messe_action_grace',
      imageAsset: 'assets/images/masses/action_grace.jpg',
      title: 'Messe d’Action de Grâce',
      subtitle: 'Rendre grâce pour les bénédictions reçues.',
      accentColor: Colors.orange,
      lottieAsset: 'assets/lottie/thanks.json',
      massTitle: 'Messe d’Action de Grâce',
      requiresBeneficiary: false,
    );
  }
}

