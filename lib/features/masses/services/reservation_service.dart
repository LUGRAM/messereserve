import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../requests/reservation_request.dart';
import '../../../core/network/api_client.dart';

class ReservationService {
  final GetStorage _box = GetStorage();

  String? get token => _box.read("token");

  Future<Map<String, dynamic>> createReservation(
      ReservationRequest request) async {

    // Injecter le token dynamiquement
    ApiClient.headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await ApiClient.post(
      "/reservations",
      request.toJson(),
    );

    final decoded = jsonDecode(response.body);

    print("========= Retour Reservation =========");
    print(decoded);

    return decoded;
  }
}
