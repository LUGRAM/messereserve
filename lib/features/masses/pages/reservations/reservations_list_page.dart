// lib/features/masses/pages/reservations/reservations_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';
import 'package:messeconnect/app/router/routes.dart';

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

  final GetStorage _box = GetStorage();

  String? get token => _box.read("token");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final data = await ReservationApi.fetchReservations(token!);
    print("========== Liste des reservation recuperee ================");
    print(data);
    setState(() {
      _reservations = data;
      _loading = false;
    });

    print("======Reservations========");
    print(_reservations);
  }

  List<ReservationModel> _filterMultiple(List<String> statuses) {
    return _reservations.where((r) => statuses.contains(r.status)).toList();
  }

  // ----------------------------------------------------------
  // BOUTON / STATUT PAIEMENT
  // ----------------------------------------------------------
  Widget _paymentButton(ReservationModel r) {
    switch (r.status) {
      case "en_attente_validation":
        return _paymentState(
          label: "Régler la commande",
          color: Colors.blueGrey.shade700,
          icon: Icons.lock,
          enabled: false,
        );

      case "en_attente_paiement":
        return _paymentState(
          label: "Régler la commande",
          color: Colors.blue,
          icon: Icons.lock_open_rounded,
          enabled: true,
          onTap: () => Get.toNamed(
            Routes.payment,
            arguments: r,
          ),
        );

      case "payee":
        return _statusBadge("Payée", Colors.green, Icons.check_circle);

      case "annulee":
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
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CARTE RÉSERVATION
  // ----------------------------------------------------------
  Widget _reservationCard(ReservationModel r) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.reservationDetail,
        arguments: r,
      ),
      child: Container(
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
        Hero(
        tag: "church_icon_${r.reference}", // Tag unique indispensable !
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.withValues(alpha: 0.15),
            child: const Icon(Icons.church, color: Colors.orange),
          ),
        ),
            /*CircleAvatar(
              radius: 26,
              backgroundColor: Colors.orange.withValues(alpha: 0.15),
              child: const Icon(Icons.church, color: Colors.orange),
            ),*/
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
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD
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
            indicatorColor: Colors.white70,
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
            _buildTab(
              _filterMultiple(
                  ["en_attente_validation", "en_attente_paiement"]),
            ),
            _buildTab(_filterMultiple(["payee"])),
            _buildTab(_filterMultiple(["refusee"])),
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
