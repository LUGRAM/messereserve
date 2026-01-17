import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';

import '../../../app/widgets/network_error_card.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<ReservationModel> _paidReservations = [];

  bool _loading = true;
  bool _hasError = false;

  final GetStorage _box = GetStorage();

  String? get token => _box.read("token");

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    try {
      if (token == null) throw Exception("Token absent");

      final all = await ReservationApi.fetchReservations(token!);

      setState(() {
        _paidReservations =
            all.where((r) => r.status == "terminee").toList();
        _loading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _hasError = true;
        _paidReservations = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        /*appBar: AppBar(
          title: const Text("Historique des paiements"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 1,
        ),*/

        appBar: AppBar(
          title: const Text("Historique des paiements"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                _loadPayments();
              },
            )
          ],
        ),

        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? NetworkErrorCard(
          title: "Connexion indisponible",
          message:
          "Impossible de charger l’historique des paiements.\nVérifiez votre connexion puis réessayez.",
          onRetry: () {
            setState(() {
              _loading = true;
              _hasError = false;
            });
            _loadPayments();
          },
        )
            : _paidReservations.isEmpty
            ? _emptyView()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _paidReservations.length,
          itemBuilder: (_, i) =>
              _paymentCard(_paidReservations[i]),
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
          Text(
            "Aucun paiement trouvé",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            "Vos paiements apparaîtront ici après validation.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }


  Widget _paymentCard(ReservationModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x80DF274C), Color(0x80F26E5A)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r.massTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text("Référence : ${r.reference}",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date : ${r.date} - ${r.time}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white)),
                Text(r.paroisseName ?? "Paroisse inconnue",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const Divider(height: 24, color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Montant : ${r.amount ?? "—"} FCFA",
                    style:
                    const TextStyle(fontSize: 15, color: Colors.white)),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        (r.paymentMethod != null && r.paymentMethod == 'AM') ? 'assets/icons/airtel.jpg' : 'assets/icons/moov.jpg',
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.sim_card, size: 20, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (r.paymentMethod != null && r.paymentMethod == 'AM') ? 'AirtelMoney' : 'MoovMoney',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Paiement réussi",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
