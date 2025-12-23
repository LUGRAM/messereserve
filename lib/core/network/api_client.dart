import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "http://192.168.1.64:8080/api";

  /// Headers par défaut
  static Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  /// Méthode POST
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
  }

  /// Méthode GET
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.get(
      url,
      headers: headers,
    );
  }

  /// Méthode PUT
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
  }

  /// Méthode DELETE
  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.delete(
      url,
      headers: headers,
    );
  }
}
