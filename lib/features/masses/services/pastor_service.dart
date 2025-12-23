import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../models/pastor_model.dart';

class PastorService {
  Future<List<PastorModel>> getPastors() async {
    try {
      final response = await ApiClient.get("/pretres");

      final List data = jsonDecode(response.body);

      return data.map((e) => PastorModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Erreur API pasteurs");
    }
  }
}
