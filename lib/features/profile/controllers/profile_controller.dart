import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  // ==========================
  // STATE
  // ==========================
  final isLoading = false.obs;
  final profile = Rxn<UserProfile>();
  final error = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // ==========================
  // INIT → API UNIQUEMENT
  // ==========================
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ==========================
  // GET PROFILE (API)
  // ==========================
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _profileService.getProfile();
      profile.value = UserProfile.fromJson(data);

      print("PROFILE LOADED => ${profile.value?.name}");

    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
      print("LOAD PROFILE ERROR => $error");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // UPDATE PROFILE (API)
  // ==========================
  Future<void> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? password,
  }) async {
    try {
      isLoading.value = true;

      await _profileService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      // Recharger depuis l'API
      await loadProfile();

      Get.back();  // Fermer l'écran d'édition

      Get.snackbar(
        'Succès',
        'Profil mis à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // UPLOAD AVATAR (API)
  // ==========================
  Future<void> pickAndUploadAvatar(ImageSource source) async {
    try {
      print("🎯 pickAndUploadAvatar CALLED with source: $source");

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) {
        print("❌ No image selected");
        return;
      }

      print("✅ Image selected: ${image.path}");

      isLoading.value = true;

      await _profileService.uploadAvatar(File(image.path));

      // Recharger profil depuis l'API
      await loadProfile();

      // ⚠️ NE PAS FERMER L'ÉCRAN ICI
      // L'utilisateur reste sur l'écran d'édition pour voir le résultat

      Get.snackbar(
        'Succès',
        'Photo de profil mise à jour',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      print("❌ UPLOAD ERROR => $e");
      Get.snackbar(
        'Erreur',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}