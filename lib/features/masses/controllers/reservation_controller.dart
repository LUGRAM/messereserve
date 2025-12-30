import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:messeconnect/features/masses/controllers/reservation_status.dart';

import '../requests/reservation_request.dart';
import '../services/reservation_service.dart';

class ReservationController extends GetxController {
  final ReservationService _service = ReservationService();

  final status = ReservationStatus.idle.obs;
  final errorMessage = ''.obs;
  final reservationResponse = Rxn<Map<String, dynamic>>();

  Future<void> submitReservation(ReservationRequest request) async {
    try {
      status.value = ReservationStatus.loading;
      errorMessage.value = '';

      final response = await _service
          .createReservation(request)
          .timeout(const Duration(seconds: 15));

      // Laravel retourne directement la commande
      if (response != null && response['reference'] != null) {
        reservationResponse.value = response;
        status.value = ReservationStatus.success;
      } else {
        errorMessage.value = "Échec de l'envoi de la commande";
        status.value = ReservationStatus.failure;
      }
    } catch (e) {
      errorMessage.value =
      "Impossible de contacter le serveur.\nVérifiez votre connexion.";
      status.value = ReservationStatus.failure;
    }
  }


  void resetStatus() {
    status.value = ReservationStatus.idle;
    errorMessage.value = '';
  }
}

