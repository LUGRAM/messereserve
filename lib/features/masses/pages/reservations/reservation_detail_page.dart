import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';

class ReservationDetailPage extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailPage({
    super.key,
    required this.reservation,
  });

  Color _statusColor(String status) {
    switch (status) {
      case "pending_payment":
        return Colors.orange;
      case "paid":
        return Colors.green;
      case "rejected":
        return Colors.grey;
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

  @override
  Widget build(BuildContext context) {
    final r = reservation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la réservation"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            r.massTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Réf : \${r.reference}",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // Date & heure
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Date & heure :", style: TextStyle(fontSize: 16)),
              Text("\${r.date} - \${r.time}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),

          // Paroisse
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Paroisse :", style: TextStyle(fontSize: 16)),
              Text(r.paroisseName ?? "Non précisée",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),

          const SizedBox(height: 14),

          // Pasteur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pasteur :", style: TextStyle(fontSize: 16)),
              Text(r.pastorName ?? "Non précisé", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),

          // Statut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Statut :", style: TextStyle(fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(r.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(r.status),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 14),

          if (r.status == "pending_payment")
            ElevatedButton.icon(
              icon: const Icon(Icons.payments),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.push('/payment-choice', extra: r);
              },
              label: const Text(
                "Régler la commande",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),

          if (r.status == "paid")
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: null,
              label: const Text("Déjà payée"),
            ),

          if (r.status == "pending_validation")
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
              ),
              child: const Text("En attente de validation"),
            ),

          if (r.status == "rejected")
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade600,
              ),
              child: const Text("Commande annulée"),
            ),
        ],
      ),
    );
  }
}
