import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../parish/models/paroisse_model.dart';

class ParoisseService {
  Future<List<ParoisseModel>> getParoisses() async {
    try {
      final response = await ApiClient.get("/paroisses");

      final List data = jsonDecode(response.body);

      return data.map((e) => ParoisseModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Erreur API paroisses");
    }
  }
}
