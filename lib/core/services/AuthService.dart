import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../network/api_client.dart';

class AuthService {
  final GetStorage _box = GetStorage();

  // Sauvegarder token
  void saveToken(String token) {
    _box.write("token", token);
  }

  // Lire token
  String? get token => _box.read("token");

  // Supprimer token
  void logout() {
    _box.remove("token");
  }

  // ========= REGISTER =========
  Future<Map<String, dynamic>?> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await ApiClient.post(
      "/register",
      {
        "name": name,
        "phone": phone,
        "password": password,
        "password_confirmation": password,
      },
    );

    final decoded = jsonDecode(response.body);

    print("========= Retour Register =========");
    print(decoded);

    if (decoded["access_token"] != null) {
      saveToken(decoded["access_token"]);
    }

    return decoded;
  }

  // ========= LOGIN =========
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await ApiClient.post(
      "/login",
      {
        "phone": phone,
        "password": password,
      },
    );

    final decoded = jsonDecode(response.body);

    print("========= Retour Login =========");
    print(decoded);

    if (decoded["access_token"] != null) {
      saveToken(decoded["access_token"]);
    }

    return decoded;
  }
}
