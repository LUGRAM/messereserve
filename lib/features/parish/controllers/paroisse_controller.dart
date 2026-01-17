import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/paroisse_model.dart';
import '../../masses/services/paroisse_service.dart';

class ParoisseController extends GetxController {
  final _service = ParoisseService();

  final isLoading = false.obs;
  final hasError = false.obs;
  final paroisses = <ParoisseModel>[].obs;

  Future<void> loadParoisses() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      paroisses.value = await _service.getParoisses();
    } catch (e) {
      hasError.value = true;
      paroisses.clear();
      debugPrint("Erreur paroisses : $e");
    } finally {
      isLoading.value = false;
    }
  }

}
