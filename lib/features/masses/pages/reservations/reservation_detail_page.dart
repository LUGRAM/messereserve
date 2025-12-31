// lib/features/masses/pages/reservations/reservation_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/app/router/routes.dart';

class ReservationDetailPage extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailPage({
    super.key,
    required this.reservation,
  });

  // ----------------------------------------------------------
  // LOGIQUE COULEURS & LABELS
  // ----------------------------------------------------------
/*  Color _statusColor(String status) {
    switch (status) {
      case "pending_payment":
        return Colors.orange;
      case "paid":
        return Colors.green;
      case "rejected":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case "pending_payment":
        return "En attente de paiement";
      case "paid":
        return "Payée";
      case "rejected":
        return "Annulée";
      default:
        return "En attente de validation";
    }
  }
*/

  Color _statusColor(String status) {
    switch (status) {
      case "en_attente_paiement":
        return Colors.blue; // Bleu pour l'action possible
      case "payee":
        return Colors.green;
      case "refusee":
      case "annulee":
        return Colors.redAccent;
      case "en_attente_validation":
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case "en_attente_paiement":
        return "En attente de paiement";
      case "payee":
        return "Payée";
      case "refusee":
      case "annulee":
        return "Annulée";
      case "en_attente_validation":
      default:
        return "En attente de validation";
    }
  }
  // ----------------------------------------------------------
  // WIDGETS DÉCOUPÉS (Clean Code)
  // ----------------------------------------------------------
  Widget _buildHeader(ReservationModel r) {
    return Column(
      children: [
        Hero(
          tag: "church_icon_${r.reference}", // Doit être IDENTIQUE au tag de la liste
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            // Note: Material est nécessaire dans un Hero si tu as du texte ou des formes spécifiques
            // pour éviter les soucis de style pendant le vol, mais pour une icône c'est souvent ok.
            child: const Icon(Icons.church, size: 40, color: Colors.deepOrange),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          r.massTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Réf : ${r.reference}",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ReservationModel r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Statut :",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(r.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _statusColor(r.status).withOpacity(0.5),
              ),
            ),
            child: Text(
              _statusLabel(r.status),
              style: TextStyle(
                color: _statusColor(r.status),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ReservationModel r) {
    // CAS 1 : Débloqué pour le paiement
    if (r.status == "en_attente_paiement") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.lock_open_rounded, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
          onPressed: () => Get.toNamed(Routes.payment, arguments: r),
          label: const Text(
            "Régler la commande",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // CAS 2 : Boutons d'état (Passifs)
    IconData icon;
    String text;
    Color bgColor;

    switch (r.status) {
      case "payee":
        bgColor = Colors.green;
        icon = Icons.check_circle;
        text = "Commande payée";
        break;
      case "refusee":
      case "annulee":
        bgColor = Colors.redAccent.withOpacity(0.8);
        icon = Icons.cancel;
        text = "Commande annulée";
        break;
      case "en_attente_validation":
      default:
        bgColor = Colors.blueGrey.shade400; // Aspect grisé/verrouillé
        icon = Icons.lock;
        text = "En attente de validation";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  // ----------------------------------------------------------
  // MAIN BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final r = reservation;

    return Container(
      // 1. Fond Dégradé identique à la liste
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff89223B), Color(0xffAC4B5B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Détails"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 2. Carte "Ticket" blanche
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(r),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    // Informations
                    _buildInfoRow(
                        "Date & heure", "${r.date} à ${r.time}",
                        isBold: true),
                    _buildInfoRow(
                        "Paroisse", r.paroisseName ?? "Non précisée"),
                    _buildInfoRow(
                        "Pasteur", r.pastorName ?? "Non précisé"),

                    // Statut spécifique
                    _buildStatusRow(r),

                    const SizedBox(height: 32),

                    // Bouton d'action
                    _buildActionButton(r),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Petit lien retour discret ou copyright si besoin
              Text(
                "MesseConnect",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}