import 'package:get/get.dart';
import '../models/paroisse_model.dart';
import '../../masses/services/paroisse_service.dart';

class ParoisseController extends GetxController {
  final _service = ParoisseService();

  var paroisses = <ParoisseModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadParoisses() async {
    try {
      isLoading.value = true;
      paroisses.value = await _service.getParoisses();
    } catch (e) {
      print("Erreur : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
