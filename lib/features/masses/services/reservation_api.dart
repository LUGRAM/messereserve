//\lib\features\masses\services\reservation_api.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messeconnect/core/network/api_client.dart';

import '../models/reservation_model.dart';
import '../requests/reservation_request.dart';

class ReservationApi {
  static Future<Map<String, dynamic>> createReservation(
      ReservationRequest req) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "success": true,
      "reference": "MC-${DateTime.now().millisecondsSinceEpoch}",
      "status": "pending_validation",
      "data": req.toJson(),
    };
  }

  static Future<List<ReservationModel>> fetchReservations(String token) async {
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/mes-commandes-messes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode != 200 || json['status'] != 1) {
      throw Exception(json['message'] ?? 'Erreur de chargement');
    }

    final List list = json['data'];

    print(list);

    return list
        .map((e) => ReservationModel.fromApi(e))
        .toList();
  }
}
