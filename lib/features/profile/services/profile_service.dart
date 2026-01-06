// lib/features/profile/services/profile_service.dart
import '../../../core/services/AuthService.dart';

class ProfileService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> getProfile() async {
    // AuthService fait déjà les appels HTTP + décodage JSON
    //return await _authService.getMe();
  }
}
