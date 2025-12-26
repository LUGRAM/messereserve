import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/AuthService.dart';
import '../../../app/router/routes.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();
  final GetStorage _storage = GetStorage();

  final isLoading = false.obs;

  // ========= REGISTER =========
  Future<bool> register(String name, String phone, String password) async {
    isLoading.value = true;

    try {
      final decoded = await _service.register(
        name: name,
        phone: phone,
        password: password,
      );

      final token = decoded?['access_token'];

      if (token != null) {
        _storage.write('auth_token', token);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ========= LOGIN =========
  Future<bool> login(String phone, String password) async {
    isLoading.value = true;

    try {
      final decoded = await _service.login(
        phone: phone,
        password: password,
      );

      final token = decoded?['access_token'];

      if (token != null) {
        _storage.write('auth_token', token);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ========= LOGOUT =========
  void logout() {
    _storage.remove('auth_token');
    _service.logout();

    Get.offAllNamed(Routes.login);
  }
}
