import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../router/routes.dart';

class AuthMiddleware extends GetMiddleware {
  final _storage = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final String? token = _storage.read('auth_token');

    final isPublicRoute = route == Routes.login ||
        route == Routes.register ||
        route == Routes.onboarding ||
        route == Routes.splash;

    if (token == null || token.isEmpty) {
      if (!isPublicRoute) {
        return const RouteSettings(name: Routes.login);
      }
    }

    return null; // accès autorisé
  }
}
