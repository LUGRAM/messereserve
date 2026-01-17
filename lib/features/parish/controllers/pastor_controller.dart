import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pastor_model.dart';
import '../../masses/services/pastor_service.dart';

class PastorController extends GetxController {
  final _service = PastorService();

  final pastors = <PastorModel>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  Future<void> loadPastors() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final data = await _service.getPastors();
      pastors.assignAll(data);
    } catch (e) {
      hasError.value = true;
      pastors.clear();
      debugPrint("PastorController error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
