import 'package:get/get.dart';
import '../models/pastor_model.dart';
import '../../masses/services/pastor_service.dart';

class PastorController extends GetxController {
  final _service = PastorService();

  var pastors = <PastorModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadPastors() async {
    try {
      isLoading.value = true;
      pastors.value = await _service.getPastors();
    } catch (e) {
      print("Erreur : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
