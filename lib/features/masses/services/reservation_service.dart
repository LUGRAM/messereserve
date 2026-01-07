import 'dart:convert';
import '../requests/reservation_request.dart';
import '../../../core/network/api_client.dart';

class ReservationService {
  Future<Map<String, dynamic>> createReservation(
      ReservationRequest request,
      ) async {
    final response = await ApiClient.post(
      "/commande-messe",
      request.toJson(),
    );

    return jsonDecode(response.body);
  }
}
