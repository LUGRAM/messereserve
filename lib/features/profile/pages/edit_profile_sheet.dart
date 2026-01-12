import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/profile_controller.dart';
import '../widgets/neo_field.dart';
import '../widgets/neo_phone_field.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _phoneValue;

  final ProfileController controller = Get.find();

  // =====================================================
  // INIT → ALIMENTÉ PAR API (via controller.profile)
  // =====================================================
  @override
  void initState() {
    super.initState();

    final user = controller.profile.value;

    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email ?? '';
      _phoneValue = user.phone;
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // =====================================================
  // PHOTO OPTIONS (API DIRECT)
  // =====================================================
  void _openPhotoOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Photo de profil",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Importer une photo"),
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Prendre une photo"),
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // SAVE PROFILE
  // =====================================================
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await controller.updateProfile(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneValue,
    );
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary2),
          onPressed: Get.back,
        ),
        title: const Text(
          "Modifier le profil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary2,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isLoading.value ? null : _save,
            child: controller.isLoading.value
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              "Enregistrer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          )),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.profile.value;
        if (user == null) {
          return const Center(child: Text("Profil indisponible"));
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                Color(0xFFFFF1F3),
              ],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ================= AVATAR =================
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.22,
                          child: Lottie.asset(
                            'assets/lottie/halo_soft.json',
                            width: 190,
                            height: 190,
                          ),
                        ),
                        GestureDetector(
                          onTap: _openPhotoOptions,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage: user.photo != null
                                ? NetworkImage(
                              "https://admin.itmaster-africa.com/storage/${user.photo}",
                            )
                                : null,
                            child: user.photo == null
                                ? Icon(
                              Icons.person,
                              size: 64,
                              color: AppColors.primary,
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: _cameraButton(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ================= FORM =================
                  _label("Nom"),
                  NeoField(
                    icon: Icons.person_outline,
                    child: TextFormField(
                      controller: _nameCtrl,
                      decoration: _inputDecoration("Votre nom"),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Champ requis" : null,
                      style: TextStyle(color: AppColors.textPrimary2),
                    ),
                  ),

                  _label("Email"),
                  NeoField(
                    icon: Icons.email_outlined,
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration("email@example.com"),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Champ requis";
                        final regex =
                        RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                        return regex.hasMatch(v)
                            ? null
                            : "Email invalide";
                      },
                      style: TextStyle(color: AppColors.textPrimary2),
                    ),
                  ),

                  _label("Téléphone"),
                  NeoPhoneField(
                    phoneValue: _phoneValue,
                    onChanged: (value) => _phoneValue = value,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // =====================================================
  Widget _cameraButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.border,
            blurRadius: 6,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.camera_alt,
          size: 18,
          color: AppColors.primaryDark,
        ),
        onPressed: _openPhotoOptions,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return const InputDecoration(
      border: InputBorder.none,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
