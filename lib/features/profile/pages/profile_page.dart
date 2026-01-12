import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_sheet.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());

  void _confirmLogout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITRE
              const Text(
                "Déconnexion",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary2,
                ),
              ),

              const SizedBox(height: 10),

              // MESSAGE
              const Text(
                "Souhaitez-vous vraiment vous déconnecter de votre compte ?",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              // ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Get.back,
                    child: const Text(
                      "Annuler",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.find<AuthController>().logout();
                    },
                    child: const Text(
                      "Déconnecter",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.45),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary2,
        title: const Text("Profil"),
      ),
      body: Obx(() {
        final user = controller.profile.value;
        if (user == null) return const SizedBox();

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ================= AVATAR =================
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => const EditProfileSheet()),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                      AppColors.primary.withValues(alpha: 0.15),
                      backgroundImage: user.photo != null
                          ? NetworkImage(user.photo!)
                          : null,
                      child: user.photo == null
                          ? const Icon(Icons.person,
                          size: 50, color: AppColors.primary)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= COMPTE =================
            _sectionTitle("Compte"),

            _tile(
              icon: Icons.edit,
              title: "Modifier le profil",
              //onTap: () => Get.to(() => const EditProfileSheet()),
              onTap: _openEditProfile,
        ),


            _tile(
              icon: FontAwesomeIcons.unlockKeyhole,
              title: "Changer mot de passe",
              onTap: () {},
            ),

            const SizedBox(height: 40),


            // ================= LOGOUT =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.gradientBottom,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _confirmLogout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Déconnexion",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _openEditProfile() {
    Get.bottomSheet(
      const EditProfileSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

}
