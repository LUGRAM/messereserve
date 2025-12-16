import 'package:flutter/material.dart';
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';

class RequiemMassPage extends StatelessWidget {
  const RequiemMassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MassDetailBasePage(
      heroTag: 'messe_requiem',
      imageAsset: 'assets/images/masses/requiem.jpg',
      title: "Messe de Requiem",
      subtitle: "Confiez l'âme du défunt à la miséricorde de Dieu.",
      accentColor: Colors.lightBlue,
      lottieAsset: 'assets/lottie/candle.json',
      massTitle: "Messe de Requiem",
      requiresBeneficiary: true,
    );
  }
}
