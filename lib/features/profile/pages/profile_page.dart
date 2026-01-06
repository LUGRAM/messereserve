import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final controller = Get.put(ProfileController());
  // ---------------------------------------------------------------------------
  // POPUP DE DECONNEXION
  // ---------------------------------------------------------------------------
  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              Get.find<AuthController>().logout();
            },
            child: const Text("Déconnecter"),
          ),
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Mon profil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!));
        }

        final user = controller.profile.value!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.navInactive,
                  backgroundImage:
                  user.avatar != null ? NetworkImage(user.avatar!) : null,
                  child: user.avatar == null
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user.email,
                        style: const TextStyle(
                            color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text("Compte",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _tile(Icons.edit_rounded, "Modifier le profil", () {
              // route edit profile
            }),

            _tile(Icons.lock_rounded, "Changer le mot de passe", () {
              // route change password
            }),

            const SizedBox(height: 30),

            const Text("Préférences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _tile(Icons.language_rounded, "Langue de l’application", () {}),
            _tile(Icons.dark_mode_rounded,
                "Mode sombre (bientôt disponible)", () {}),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text("Déconnexion",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _confirmLogout,
            ),
          ],
        );
      }),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary2),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
