// lib/features/masses/pages/mass_detail_base_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:messeconnect/features/masses/widgets/mass_stepper_form.dart';
import '../../../app/router/routes.dart';
import '../models/mass_model.dart';

class MassDetailBasePage extends StatelessWidget {
  final String heroTag;
  final String imageAsset;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String lottieAsset;
  final String massTitle;
  final String massAmount;
  final bool requiresBeneficiary;

  MassDetailBasePage({
    super.key,
    required this.heroTag,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.lottieAsset,
    required this.massTitle,
    required this.massAmount,
    required this.requiresBeneficiary,
  });

  factory MassDetailBasePage.forMass(MassModel mass) {
    return MassDetailBasePage(
      heroTag: mass.heroTag,
      imageAsset: mass.imageAsset,
      title: mass.title,
      subtitle: mass.subtitle,
      accentColor: mass.accentColor,
      lottieAsset: mass.lottieAsset,
      massTitle: mass.title,
      massAmount: mass.amount,
      requiresBeneficiary: mass.requiresBeneficiary,
    );
  }

  void _handleBack() {
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  final String massId = Get.parameters['id'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // HERO — IMAGE
          Positioned.fill(
            child: Hero(
              tag: heroTag,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // OVERLAY SOMBRE
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),

          // CONTENU
          SafeArea(
            child: LayoutBuilder(
              builder: (_, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // HEADER
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: _handleBack,
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // BLOC CONTENU
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    40, 255, 255, 255),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    subtitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Lottie.asset(
                                    lottieAsset,
                                    height: 140,
                                    errorBuilder: (_, __, ___) =>
                                    const SizedBox.shrink(),
                                  ),

                                  const SizedBox(height: 6),

                                  MassStepperForm(
                                    id: massId,
                                    accentColor: accentColor,
                                    massTitle: massTitle,
                                    massAmount: massAmount,
                                    requiresBeneficiary:
                                    requiresBeneficiary,
                                                                      ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
