import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reservation_controller.dart';

class ReservationFailedPage extends StatelessWidget {
  final String message;

  const ReservationFailedPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Utilisation des couleurs du thème ou des couleurs ecclésiastiques (Bordeaux/Or)
    const primaryColor = Color(0xFF8B0000); // Un rouge profond/sacré

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.black87,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Iconographie plus symbolique (un clocher ou une main en prière barrée)
              const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.church_outlined,
                    size: 100,
                    color: Colors.white10,
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                "Action interrompue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                  fontFamily: 'Serif', // Pour un aspect plus solennel
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bouton stylisé "Pro"
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.find<ReservationController>().resetStatus();
                    Get.back();
                  },
                  child: const Text(
                    "RETOUR AU FORMULAIRE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: const Text(
                  "Retour à l'accueil",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}