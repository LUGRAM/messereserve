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
      // Utilisation de borderRadius sur le InkWell pour que l'effet de ripple soit propre
      borderRadius: BorderRadius.circular(20),
      onTap: () => Get.toNamed(
        Routes.reservationDetail,
        arguments: r,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // Bordure subtile pour un aspect premium
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Petit accent de couleur sur le côté
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(width: 5, color: Colors.orangeAccent),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // --- HERO UNIQUE ---
                    Hero(
                      tag: "res_icon_${r.reference}",
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.church, // Changement pour un look plus "spirituel/éclatant"
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // --- INFOS ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.massTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                r.date,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.access_time, size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                r.time,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- ACTION ---
                    _paymentButton(r),
                  ],
                ),
              ),
            ],
          ),
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
