import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParishDetailsPage extends StatelessWidget {
  const ParishDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text("Détails de la paroisse", style: TextStyle(color: Colors.black)),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade300,
              image: const DecorationImage(
                image: AssetImage("assets/images/parish.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text("Paroisse Saint Michel",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Libreville, Gabon", style: TextStyle(color: Colors.grey.shade700)),

          const SizedBox(height: 20),

          const Text("Informations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _info(Icons.location_on, "Adresse", "Rue du Bord de Mer, Libreville"),
          _info(Icons.phone, "Téléphone", "+241 01 23 45 67"),
          _info(Icons.schedule, "Horaires", "Lun–Ven : 8h - 17h"),
          _info(Icons.person, "Prêtre responsable", "Père Alain Ndzeng"),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 26),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          )
        ],
      ),
    );
  }
}
