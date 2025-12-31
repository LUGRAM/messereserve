import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/router/routes.dart';
import '../../controllers/reservation_controller.dart';

class ReservationFailedPage extends StatelessWidget {
  final String message;

  const ReservationFailedPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A1F2A), // bordeaux liturgique doux
              Color(0xFF2C1B1F), // brun profond apaisant
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation échec (signal discret)
                Lottie.asset(
                  'assets/lottie/failed.json',
                  height: 130,
                  repeat: false,
                ),

                const SizedBox(height: 28),

                const Text(
                  "Action interrompue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.6,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 42),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1E2E),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {
                      Get.find<ReservationController>().resetStatus();
                      Get.back();
                    },
                    child: const Text(
                      "RETOUR AU FORMULAIRE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.home),
                  child: const Text(
                    "Retour à l'accueil",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
