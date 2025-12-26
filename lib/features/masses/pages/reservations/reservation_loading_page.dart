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
      backgroundColor: Colors.white60,
      body: Center(
        child: Obx(() {
          switch (ctrl.status.value) {
            case ReservationStatus.loading:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Envoi de la réservation...\nVeuillez patienter",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              );

            case ReservationStatus.success:
              final data = ctrl.reservationResponse.value!;
              return ReservationSentPage(
                reference: data['reference'],
                massTitle: data['mass_title'] ?? '',
                date: data['date'] ?? '',
                time: data['time'] ?? '',
                pastorName: data['pastor'],
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
    );
  }
}
