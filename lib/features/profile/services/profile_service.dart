import 'dart:io';
import 'dart:convert';
import '../../../core/network/api_client.dart';

class ProfileService {

  // ==========================
  // GET PROFILE
  // ==========================
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get('/profile');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == true && json['data'] != null) {
        return json['data'];
      }

      throw Exception(json['message'] ?? 'Profil introuvable');
    }

    if (response.statusCode == 401) {
      throw Exception('Session expirée');
    }

    throw Exception('Erreur serveur (${response.statusCode})');
  }

  // ==========================
  // UPDATE PROFILE
  // ==========================
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? password,
  }) async {
    final payload = {
      'name': name,
      'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (password != null && password.isNotEmpty) 'password': password,
    };

    final response = await ApiClient.put('/profile', payload);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // Swagger: succès sans data OU avec data
      if (json['status'] == true) {
        return json['data'] ?? {};
      }

      throw Exception(json['message'] ?? 'Échec mise à jour');
    }

    if (response.statusCode == 401) {
      throw Exception('Session expirée');
    }

    throw Exception('Erreur serveur (${response.statusCode})');
  }

  // ==========================
  // UPLOAD AVATAR
  // ==========================
  Future<void> uploadAvatar(File image) async {
    final response = await ApiClient.multipart(
      endpoint: '/profile/photo',
      fileField: 'photo',
      file: image,
    );

    if (response.statusCode != 200) {
      throw Exception('Échec upload photo');
    }
  }

}
