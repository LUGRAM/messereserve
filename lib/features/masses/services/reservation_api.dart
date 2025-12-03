import 'dart:async';

import 'package:messeconnect/features/masses/models/reservation_request.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';

class ReservationApi {
  /// MOCK avant Laravel : simule un appel réseau
  static Future<Map<String, dynamic>> createReservation(
      ReservationRequest req,
      ) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API latency

    // MOCK response comme Laravel renverra plus tard
    return {
      "success": true,
      "reference": "MC-${DateTime.now().millisecondsSinceEpoch}",
      "status": "pending_validation",
      "data": req.toJson(),
    };
  }

  // -------------------------------------------------------------
  // MOCK GET /reservations
  // -------------------------------------------------------------
  static Future<List<ReservationModel>> fetchReservations() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate latency

    final mockData = [
      {
        "reference": "MC-20250228-A1B2C3",
        "mass_title": "Messe de Requiem",
        "date": "27/02/2025",
        "time": "10:00",
        "status": "pending_validation",
        "pastor_name": "Père Alain Ndzeng",
      },
      {
        "reference": "MC-20250227-X9Z7T3",
        "mass_title": "Messe d’Action de Grâce",
        "date": "28/02/2025",
        "time": "14:00",
        "status": "paid",
        "pastor_name": null,
      },
    ];

    return mockData.map((e) => ReservationModel.fromJson(e)).toList();
  }
}
