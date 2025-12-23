import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
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

  List<ReservationModel> _filterMultiple(List<String> statuses) {
    return _reservations.where((r) => statuses.contains(r.status)).toList();
  }

  // ----------------------------------------------------------
  // BOUTON PAIEMENT
  // ----------------------------------------------------------
  Widget _paymentButton(ReservationModel r) {
    switch (r.status) {
      case "pending_validation":
        return _paymentState(
          label: "Régler la commande",
          color: Colors.blueGrey.shade700,
          icon: Icons.lock,
          enabled: false,
        );

      case "pending_payment":
        return _paymentState(
          label: "Régler la commande",
          color: Colors.blue,
          icon: Icons.lock_open_rounded,
          enabled: true,
          onTap: () => context.push('/payment', extra: r),
        );

      case "paid":
        return _statusBadge("Payée", Colors.green, Icons.check_circle);

      case "rejected":
        return _statusBadge("Annulée", Colors.grey.shade700, Icons.cancel);

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
          color: color.withValues(alpha: enabled ? 1.0 : 0.5),
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

  Widget _statusBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
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
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.withValues(alpha: 0.15),
            child: const Icon(Icons.church, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.massTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
    return Container(
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
          title: const Text("Mes Réservations"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 1,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.deepOrangeAccent,
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
            _buildTab(_filterMultiple(["pending_validation", "pending_payment"])),
            _buildTab(_filterMultiple(["paid"])),
            _buildTab(_filterMultiple(["rejected"])),
          ],
        ),
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
