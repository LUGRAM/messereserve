import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation_controller.dart';
import '../../controllers/reservation_status.dart';
import 'reservation_sent_page.dart';
import 'reservation_failed_page.dart';

class ReservationLoadingPage extends StatelessWidget {
  ReservationLoadingPage({super.key});

  final ReservationController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A1F2A), // bordeaux liturgique
              Color(0xFF2C1B1F), // brun profond
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Obx(() {
              switch (ctrl.status.value) {
                case ReservationStatus.loading:
                  return _buildLoadingCard();

                case ReservationStatus.success:
                  final data = ctrl.reservationResponse.value!;
                  return ReservationSentPage(
                    reference: data['reference'] ?? 'N/A',
                    massTitle: data['display_title'] ?? 'Messe',
                    date: data['display_date'] ?? '',
                    time: data['display_time'] ?? '',
                    pastorName: data['pastor']?['nom'],
                  );

                case ReservationStatus.failure:
                  return ReservationFailedPage(
                    message: ctrl.errorMessage.value,
                  );

                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // Loader plus noble
          SizedBox(
            width: 54,
            height: 54,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFF2E8D5), // ivoire doux / or pâle
              ),
            ),
          ),

          SizedBox(height: 26),

          Text(
            "Envoi de la réservation",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Veuillez patienter quelques instants.\nVotre demande est en cours de transmission.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
