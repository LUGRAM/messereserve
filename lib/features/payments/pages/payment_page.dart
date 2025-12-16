import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<ReservationModel> _pendingPayments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final all = await ReservationApi.fetchReservations();

    setState(() {
      _pendingPayments = all
          .where((r) => r.status == "pending_payment")
          .toList();

      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          title: const Text("Paiements"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),

        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _pendingPayments.isEmpty
            ? _emptyView()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _pendingPayments.length,
          itemBuilder: (_, i) {
            final r = _pendingPayments[i];
            return _paymentCard(context, r);
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Vue vide
  // ---------------------------------------------------------------------------
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payments_rounded, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          const Text(
            "Aucun paiement en attente",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Vos messes validées apparaîtront ici.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Carte d'une messe à payer
  // ---------------------------------------------------------------------------
  Widget _paymentCard(BuildContext context, ReservationModel r) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),

      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              r.massTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text("Réf : ${r.reference}",
                style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${r.date} - ${r.time}",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  r.paroisseName ?? "Paroisse inconnue",
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.lock),
                onPressed: () {
                  context.push('/payment-choice'); // GoRouter navigation
                },
                label: const Text(
                  "Payer maintenant",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
