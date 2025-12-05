import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messeconnect/features/masses/widgets/mass_stepper_form.dart';

import '../../../app/theme/app_colors.dart';

class MassDetailBasePage extends StatelessWidget {
  final String heroTag;
  final String imageAsset;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String lottieAsset;
  final String massTitle;
  final bool requiresBeneficiary;

  const MassDetailBasePage({
    super.key,
    required this.heroTag,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.lottieAsset,
    required this.massTitle,
    required this.requiresBeneficiary,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        // GRADIENT FIXÉ – NE BOUGE PLUS
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.massRedTop,
              AppColors.massRedBottom,
            ],
          ),
        ),

        child: Stack(
          children: [

            // IMAGE AVEC HERO (SANS FLASH)
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
                color: Colors.black.withValues(alpha:0.45),
              ),
            ),

            // CONTENU AVEC SCROLL FIX – PLUS DE FOND NOIR
            SafeArea(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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
                                    onPressed: () =>
                                        Navigator.pop(context),
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

                              // BLOC BLANC FLOUTÉ
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(40, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(22),
                                ),

                                child: Column(
                                  children: [

                                    // SOUS-TITRE
                                    Text(
                                      subtitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // LOTTIE
                                    Lottie.asset(
                                      lottieAsset,
                                      height: 140,
                                    ),

                                    const SizedBox(height: 6),

                                    // FORMULAIRE MULTI-ÉTAPES
                                    MassStepperForm(
                                      accentColor: accentColor,
                                      massTitle: massTitle,
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
      ),
    );
  }
}
