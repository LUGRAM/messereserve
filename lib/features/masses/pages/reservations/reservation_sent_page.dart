import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservations_list_page.dart';

class ReservationSentPage extends StatelessWidget {
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String? pastorName;

  const ReservationSentPage({
    super.key,
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    this.pastorName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Animation Lottie
                Lottie.asset(
                  "assets/lottie/check_success.json",
                  height: size.height * 0.25,
                ),

                const SizedBox(height: 10),

                Text(
                  "Réservation envoyée",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Votre demande a bien été enregistrée.\nElle est maintenant en attente de validation par la paroisse.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 30),

                _infoCard(),

                const Spacer(),

                _buttons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Référence", reference),
          _row("Type de messe", massTitle),
          _row("Date", date),
          _row("Heure", time),
          if (pastorName != null) _row("Pasteur choisi", pastorName!),
          _row("Statut", "En attente de validation",
              valueColor: Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Retour à l'accueil"),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReservationsListPage()),
              );
            },
            child: const Text("Voir mes réservations"),
          ),
        ),

      ],
    );
  }
}
