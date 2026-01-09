// lib/features/masses/pages/reservations/reservation_sent_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/router/routes.dart';

class ReservationSentPage extends StatelessWidget {
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String paroisseName;
  final String? pastorName;

  const ReservationSentPage({
    super.key,
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    required this.paroisseName,
    this.pastorName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Animation succès (boucle OK)
                Lottie.asset(
                  "assets/lottie/success.json",
                  height: size.height * 0.25,
                ),

                const SizedBox(height: 16),

                Text(
                  "Réservation envoyée",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Votre demande de messe a été officiellement enregistrée par la paroisse.\n\n"
                      "Afin de permettre la confirmation définitive de cette Messe, "
                      "nous vous invitons à procéder au règlement correspondant.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                _officialCard(),

                const SizedBox(height: 24),

                _processCard(),

                const SizedBox(height: 32),

                _paymentButton(),

                const SizedBox(height: 24),

                Text(
                  "MesseConnect",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // INFO CARD (résumé rapide)
  // ==========================================================
  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Référence", reference),
          _row("Type de messe", massTitle),
          _row("Date", date),
          _row("Heure", time),
          _row(
            "Statut",
            "En attente de validation",
            valueColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CARTE OFFICIELLE
  // ==========================================================
  Widget _officialCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DEMANDE DE MESSE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Référence : $reference",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const Divider(height: 32),

          _rowDark("Type de messe", massTitle),
          _rowDark("Date", date),
          _rowDark("Heure", time),
          _rowDark("Paroisse", paroisseName),
          if (pastorName != null)
            _rowDark("Pasteur", pastorName!),

          const SizedBox(height: 16),

          _statusBadge(),
        ],
      ),
    );
  }

  Widget _rowDark(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, size: 16, color: Colors.orange),
          SizedBox(width: 6),
          Text(
            "En attente de paiement",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROCESSUS
  // ==========================================================
  Widget _processCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Processus de traitement",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 12),
          _ProcessItem("Votre demande est transmise à la paroisse"),
          _ProcessItem("Le règlement permet la prise en compte officielle"),
          _ProcessItem("La paroisse valide selon son calendrier"),
          _ProcessItem("Une confirmation vous sera notifiée"),
        ],
      ),
    );
  }

  // ==========================================================
  // CTA
  // ==========================================================
  Widget _paymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.lock, size: 22),
        label: const Text(
          "Procéder au paiement sécurisé",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          Get.toNamed(
            Routes.payment.replaceFirst(':reference', reference),
          );
        },
      ),
    );
  }
}

// ============================================================
// ITEM PROCESSUS
// ============================================================
class _ProcessItem extends StatelessWidget {
  final String text;

  const _ProcessItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 18, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
