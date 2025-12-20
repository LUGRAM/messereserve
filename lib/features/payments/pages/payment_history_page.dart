import 'package:flutter/material.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<ReservationModel> _paidReservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    final all = await ReservationApi.fetchReservations();
    setState(() {
      _paidReservations = all.where((r) => r.status == "paid").toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Historique des paiements"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _paidReservations.isEmpty
            ? _emptyView()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _paidReservations.length,
          itemBuilder: (_, i) => _paymentCard(_paidReservations[i]),
        ),
      ),
    );
  }

  Widget _emptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.white70),
          SizedBox(height: 16),
          Text("Aucun paiement trouvé",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          SizedBox(height: 8),
          Text("Vos paiements s'afficheront ici une fois effectués.",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _paymentCard(ReservationModel r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la messe
            Text(
              r.massTitle,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Référence : ${r.reference}",
                style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${r.date} - ${r.time}",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(r.paroisseName ?? "Paroisse inconnue",
                    style: const TextStyle(color: Colors.black87)),
              ],
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Montant : ${r.amount ?? "—"} FCFA",
                    style: const TextStyle(fontSize: 15)),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/icons/${(r.operator ?? "").toLowerCase()}.jpg',
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.sim_card, size: 20, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      r.operator?.toUpperCase() ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Paiement réussi",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
