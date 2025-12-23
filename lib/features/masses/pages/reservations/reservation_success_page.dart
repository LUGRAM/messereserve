import 'package:flutter/material.dart';

class ReservationSuccessPage extends StatelessWidget {
  final String reference;

  const ReservationSuccessPage({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.greenAccent, size: 90),

              const SizedBox(height: 20),

              const Text(
                "Réservation envoyée !",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),

              const SizedBox(height: 10),

              Text(
                "Votre référence : $reference",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => Navigator.popUntil(
                    context, (route) => route.isFirst),
                child: const Text("Retour à l'accueil"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
