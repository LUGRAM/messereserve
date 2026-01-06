import 'package:get/get.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service = ProfileService();

  final isLoading = false.obs;
  final profile = Rxn<UserProfile>();
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final decoded = await _service.getProfile();

      if (decoded != null) {
        profile.value = UserProfile.fromJson(decoded);
      } else {
        error.value = "Profil introuvable";
      }
    } catch (e) {
      error.value = "Impossible de charger le profil";
    } finally {
      isLoading.value = false;
    }
  }
}
