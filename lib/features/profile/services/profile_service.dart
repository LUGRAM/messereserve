import 'dart:convert';
import 'dart:io';

import '../../../core/network/api_client.dart';

class ProfileService {

  // ==========================
  // GET PROFILE
  // ==========================
  /*Future<Map<String, dynamic>> getProfile() async {
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
  }*/
// getprofile avec log
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get('/profile');

    print("📡 STATUS CODE => ${response.statusCode}");
    print("📡 BODY => ${response.body}");

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
  Future<void> updateProfile({
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

      if (json['status'] == true) {
        return;
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
      endpoint: '/profile',
      fileField: 'photo',
      file: image,
      method: 'PUT',
    );

    // Laravel peut répondre 200 ou 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    // Lire le body d’erreur si présent
    final body = await response.stream.bytesToString();
    print(" UPLOAD STATUS => ${response.statusCode}");
    print(" UPLOAD BODY => $body");

    try {
      final json = jsonDecode(body);
      throw Exception(json['message'] ?? 'Échec upload photo');
    } catch (_) {
      throw Exception('Échec upload photo');
    }
  }
}
