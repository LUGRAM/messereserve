import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final GetStorage _storage = GetStorage();

  final isLoading = false.obs;
  final profile = Rxn<UserProfile>();
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // ==========================
    // 1 PROFIL LOCAL IMMÉDIAT
    // ==========================
    profile.value = UserProfile(
      id: _storage.read('user_id') ?? 0,
      name: _storage.read('user_name') ?? "Utilisateur",
      email: _storage.read('user_email') ?? "email@example.com",
      phone: _storage.read('user_phone'),
      avatar: null,
    );

    // ==========================
    // 2SYNCHRO API SILENCIEUSE
    // ==========================
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _profileService.getProfile();
      final user = UserProfile.fromJson(data);

      // Mise à jour UI
      profile.value = user;

      // Mise à jour cache local
      _storage.write('user_id', user.id);
      _storage.write('user_name', user.name);
      _storage.write('user_email', user.email);
      _storage.write('user_phone', user.phone);
    } catch (e) {
      // Pour ne plu s bloquer l'ui
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

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

      // resynchro
      await loadProfile();

      Get.back();
      Get.snackbar('Succès', 'Profil mis à jour avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadAvatar(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      isLoading.value = true;

      await _profileService.uploadAvatar(File(image.path));

      // resync profil
      await loadProfile();

      Get.back(); // ferme la card photo
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

}
