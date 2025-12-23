import 'package:get/get.dart';
import '../../../core/services/AuthService.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  final isLoading = false.obs;

  // ========= REGISTER =========
  Future<bool> register(String name, String phone, String password) async {
    isLoading.value = true;

    final decoded = await _service.register(
      name: name,
      phone: phone,
      password: password,
    );

    isLoading.value = false;

    // Si un token est envoyé → succès
    return decoded != null && decoded["access_token"] != null;
  }

  // ========= LOGIN =========
  Future<bool> login(String phone, String password) async {
    try {
      isLoading.value = true;

      final decoded = await _service.login(
        phone: phone,
        password: password,
      );

      print("Decode value");
      print(decoded);

      isLoading.value = false;

      return decoded["access_token"] != null;

    } catch (e) {
      print("Erreur LOGIN : $e");
      isLoading.value = false;
      return false;
    }
  }

  // ========= LOGOUT =========
  void logout() {
    _service.logout();
    Get.offAllNamed("/login");
  }
}
