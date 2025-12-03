import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';

class ReservationsListPage extends StatefulWidget {
  const ReservationsListPage({super.key});

  @override
  State<ReservationsListPage> createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ReservationModel> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final data = await ReservationApi.fetchReservations();
    setState(() {
      _reservations = data;
      _loading = false;
    });
  }

  List<ReservationModel> _filter(String status) {
    return _reservations.where((r) => r.status == status).toList();
  }

  // ----------------------------------------------------------
  // BOUTON PAIEMENT
  // ----------------------------------------------------------
  Widget _paymentButton(ReservationModel r) {
    switch (r.status) {
      case "pending_validation":
        return _paymentState(
          label: "En attente",
          color: Colors.grey.shade400,
          icon: Icons.hourglass_empty,
          enabled: false,
        );

      case "pending_payment":
        return _paymentState(
          label: "Payer",
          color: Colors.orange,
          icon: Icons.payments,
          enabled: true,
          onTap: () {
            // TODO : implémenter paiement mobile money
          },
        );

      case "paid":
        return _paymentState(
          label: "Payée",
          color: Colors.green,
          icon: Icons.check_circle,
          enabled: false,
        );

      case "rejected":
        return _paymentState(
          label: "Annulée",
          color: Colors.grey.shade500,
          icon: Icons.cancel,
          enabled: false,
        );

      default:
        return const SizedBox();
    }
  }

  Widget _paymentState({
    required String label,
    required Color color,
    required IconData icon,
    bool enabled = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: enabled ? 1 : 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CARTE RÉSERVATION
  // ----------------------------------------------------------

  Widget _reservationCard(ReservationModel r) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icone messe
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.withOpacity(0.15),
            child: const Icon(Icons.church, color: Colors.orange),
          ),

          const SizedBox(width: 12),

          // Infos principales
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.massTitle,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "${r.date} à ${r.time}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Bouton paiement (droite)
          _paymentButton(r),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CORPS
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Réservations"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black45,
          indicatorColor: Colors.deepOrange,
          tabs: const [
            Tab(text: "Demandes"),
            Tab(text: "Succès"),
            Tab(text: "Annulées"),
          ],
        ),
      ),

      body: _loading
          ? Center(
        child: Lottie.asset(
          "assets/lottie/church_glow.json",
          width: 140,
          height: 140,
        ),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          // EN DEMANDE
          _buildTab(_filter("pending_validation")),

          // SUCCÈS
          _buildTab(_filter("paid")),

          // ANNULÉES
          _buildTab(_filter("rejected")),
        ],
      ),
    );
  }

  Widget _buildTab(List<ReservationModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lottie/church_glow.json",
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 8),
            const Text(
              "Aucune réservation pour le moment",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: list.map((r) => _reservationCard(r)).toList(),
    );
  }
}
