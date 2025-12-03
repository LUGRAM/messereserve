import 'package:flutter/material.dart';
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';

class NuptialMassPage extends StatelessWidget {
  const NuptialMassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MassDetailBasePage(
      heroTag: 'messe_nuptiale',
      imageAsset: 'assets/images/masses/nuptial.jpg',
      title: 'Messe Nuptiale',
      subtitle: 'Confiez votre union à Dieu dans une atmosphère sacrée.',
      accentColor: Colors.white70,
      lottieAsset: 'assets/lottie/rings.json',
      massTitle: 'Messe Nuptiale',
      requiresBeneficiary: false,
    );
  }
}
