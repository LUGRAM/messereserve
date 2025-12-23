import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Conditions d'utilisation", style: TextStyle(color: Colors.black)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "L’utilisation de MesseConnect implique l’acceptation des conditions "
              "suivantes :\n\n"
              "1. L’utilisateur s’engage à fournir des informations exactes.\n"
              "2. Les paiements doivent être effectués via les solutions approuvées.\n"
              "3. Toute fraude ou abus peut entraîner la suspension du compte.",
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ),
    );
  }
}
