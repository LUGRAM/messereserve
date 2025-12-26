import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation_controller.dart';

class ReservationFailedPage extends StatelessWidget {
  final String message;

  const ReservationFailedPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 72, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              "Échec de la réservation",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Get.find<ReservationController>().resetStatus();
                Get.back(); // retourne au résumé
              },
              child: const Text("Retour au récapitulatif"),
            ),
          ],
        ),
      ),
    );
  }
}
