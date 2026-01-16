import 'dart:convert';
import 'dart:io';

import '../../../core/network/api_client.dart';

class ProfileService {
  // ==========================
  // GET PROFILE
  // ==========================
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get('/profile');

    print("📡 GET PROFILE STATUS => ${response.statusCode}");
    print("📡 GET PROFILE BODY => ${response.body}");

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

    print("📤 UPDATE PAYLOAD => $payload");

    final response = await ApiClient.put('/profile', payload);

    print("📡 UPDATE STATUS => ${response.statusCode}");
    print("📡 UPDATE BODY => ${response.body}");

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
    print("📤 UPLOAD AVATAR START");
    print("📤 FILE PATH => ${image.path}");
    print("📤 FILE EXISTS => ${await image.exists()}");

    // ✅ ESSAYER AVEC POST PUR (sans _method)
    final response = await ApiClient.multipart(
      endpoint: '/profile/avatar',  // ⚠️ Nouvel endpoint dédié
      fileField: 'photo',
      file: image,
      method: 'POST',
      // ❌ PAS de _method: PUT
    );

    print("📡 UPLOAD STATUS => ${response.statusCode}");

    final body = await response.stream.bytesToString();
    print("📡 UPLOAD BODY => $body");

    // Si c'est du HTML (erreur 500)
    if (body.contains('<html') || body.contains('<!DOCTYPE')) {
      print("⚠️ RESPONSE IS HTML - Laravel Exception");

      final errorMatch = RegExp(r'<h1[^>]*>(.*?)</h1>').firstMatch(body);
      if (errorMatch != null) {
        final errorMsg = errorMatch.group(1)?.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        print("💥 ERROR => $errorMsg");
        throw Exception(errorMsg ?? 'Erreur serveur Laravel');
      }

      throw Exception('Erreur 500 - Consultez les logs Laravel');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final json = jsonDecode(body);
        if (json['status'] == true) {
          print("✅ UPLOAD SUCCESS");
          return;
        }
        throw Exception(json['message'] ?? 'Échec upload photo');
      } catch (e) {
        if (e is Exception) rethrow;
        print("✅ UPLOAD SUCCESS (pas de JSON)");
        return;
      }
    }

    if (response.statusCode == 422) {
      try {
        final json = jsonDecode(body);
        final errors = json['errors'] as Map<String, dynamic>?;

        if (errors != null) {
          final firstError = errors.values.first;
          throw Exception(firstError is List ? firstError.first : firstError);
        }

        throw Exception(json['message'] ?? 'Fichier invalide');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Fichier invalide');
      }
    }

    throw Exception('Échec upload photo (${response.statusCode})');
  }
}