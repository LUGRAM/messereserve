import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

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
        title: const Text("Mentions légales", style: TextStyle(color: Colors.black)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "MesseConnect © 2025\nDéveloppé par IT-Master.\n"
              "Toutes les informations sont protégées conformément à la loi gabonaise en vigueur.",
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
