import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
        title: const Text("À propos", style: TextStyle(color: Colors.black)),
      ),
        body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "MesseConnect est une plateforme moderne dédiée à la gestion des "
              "demandes de messes, permettant aux fidèles de réserver facilement "
              "des intentions et de suivre leurs réservations.\n\n"
              "Notre mission est de simplifier la communication entre les paroisses "
              "et les fidèles grâce à une interface claire, intuitive et fiable.",
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
