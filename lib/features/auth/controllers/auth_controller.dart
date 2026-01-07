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
      final user = decoded?['user']; // attendu côté de l API

      if (token != null) {
        _storage.write('auth_token', token);
        _storage.write('token', token);

        // CACHE PROFIL (UX immédiate)
        if (user != null) {
          _storage.write('user_id', user['id']);
          _storage.write('user_name', user['name']);
          _storage.write('user_email', user['email']);
          _storage.write('user_phone', user['phone']);
        }

        return true;
      }

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
      final user = decoded?['user']; //  attendu du  côté de l API

      if (token != null) {
        _storage.write('auth_token', token);
        _storage.write('token', token);

        //  CACHE PROFIL
        if (user != null) {
          _storage.write('user_id', user['id']);
          _storage.write('user_name', user['name']);
          _storage.write('user_email', user['email']);
          _storage.write('user_phone', user['phone']);
        }

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
    _storage.remove('token');

    // Optionnel : vider cache profil
    _storage.remove('user_id');
    _storage.remove('user_name');
    _storage.remove('user_email');
    _storage.remove('user_phone');

    _service.logout();
    Get.offAllNamed(Routes.login);
  }
}
