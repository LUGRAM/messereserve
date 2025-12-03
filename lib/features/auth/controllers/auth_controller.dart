// lib/features/auth/controllers/auth_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messeconnect/features/auth/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>(
      (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  final _api = AuthApi();

  Future<void> login(String email, String pass) async {
    state = const AsyncLoading();
    try {
      final res = await _api.login(email, pass);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", res["access_token"]);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> register(String name, String email, String pass) async {
    state = const AsyncLoading();
    try {
      await _api.register(name, email, pass);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
*/