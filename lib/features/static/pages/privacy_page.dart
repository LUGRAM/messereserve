import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
        title: const Text("Confidentialité", style: TextStyle(color: Colors.black)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "MesseConnect protège vos informations personnelles conformément "
              "aux normes de protection des données.\n\n"
              "Aucune donnée n’est vendue ou partagée sans votre consentement.",
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
