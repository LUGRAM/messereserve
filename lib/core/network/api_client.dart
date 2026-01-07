import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiClient {
  static const String baseUrl = "https://admin.itmaster-africa.com/api";
  static final GetStorage _box = GetStorage();

  // =====================================================
  // TOKEN CENTRALISÉ
  // =====================================================
  static String? get _token =>
      _box.read("auth_token") ?? _box.read("token");

  // =====================================================
  // HEADERS JSON (API CLASSIQUE)
  // =====================================================
  static Map<String, String> get jsonHeaders => {
    "Accept": "application/json",
    "Content-Type": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  // =====================================================
  //  HEADERS MULTIPART (UPLOAD)
  //  Ici, Il N Y A PAS DE Content-Type
  // =====================================================
  static Map<String, String> get multipartHeaders => {
    "Accept": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  // =====================================================
  // GET
  // =====================================================
  static Future<http.Response> get(String endpoint) {
    return http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
    );
  }

  // =====================================================
  // POST
  // =====================================================
  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> data,
      ) {
    return http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
      body: jsonEncode(data),
    );
  }

  // =====================================================
  // PUT
  // =====================================================
  static Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> data,
      ) {
    return http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
      body: jsonEncode(data),
    );
  }

  // =====================================================
  // DELETE
  // =====================================================
  static Future<http.Response> delete(String endpoint) {
    return http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
    );
  }

  // =====================================================
  // MULTIPART (UPLOAD FICHIER)
  // =====================================================
  static Future<http.StreamedResponse> multipart({
    required String endpoint,
    required String fileField,
    required File file,
    Map<String, String>? fields,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint");
    final request = http.MultipartRequest('POST', uri);

    // Headers auth (sans Content-Type)
    request.headers.addAll(multipartHeaders);

    // Champs texte optionnels
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Fichier
    request.files.add(
      await http.MultipartFile.fromPath(
        fileField,
        file.path,
      ),
    );

    return request.send();
  }
}
