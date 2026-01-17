import 'dart:convert';
import 'dart:io';

import '../../../core/network/api_client.dart';

class ProfileService {
  // ==========================
  // GET PROFILE
  // ==========================
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get('/profile');

    print(" GET PROFILE STATUS => ${response.statusCode}");
    print(" GET PROFILE BODY => ${response.body}");

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

    print(" UPDATE PAYLOAD => $payload");

    final response = await ApiClient.put('/profile', payload);

    print(" UPDATE STATUS => ${response.statusCode}");
    print(" UPDATE BODY => ${response.body}");

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

    if (response.statusCode == 422) {
      final json = jsonDecode(response.body);
      final errors = json['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        final firstError = errors.values.first;
        throw Exception(firstError is List ? firstError.first : firstError);
      }

      throw Exception(json['message'] ?? 'Données invalides');
    }

    throw Exception('Erreur serveur (${response.statusCode})');
  }

  // ==========================
  // UPLOAD AVATAR (VERSION POST PURE)
  // ==========================
  Future<void> uploadAvatar(File image) async {
    final response = await ApiClient.multipart(
      endpoint: '/profile',
      fileField: 'photo',
      file: image,
      method: 'POST',       // POST est obligatoire pour le multipart sous PHP/Laravel
      fields: {
        '_method': 'PUT',   // Tunneling : Indique à Laravel de simuler un PUT
      },
    );

    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);

    if (response.statusCode == 200 && json['status'] == true) {
      // Si ça marche, json['data']['photo'] ne sera plus null !
      return;
    }
    throw Exception(json['message'] ?? 'Échec de l\'upload');
  }
}