// lib/app/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../features/auth/controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _openExternal(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }


  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.redAccent.shade100.withValues(alpha: 0.80),
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // ferme la popup
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // ferme la popup
              Get.find<AuthController>().logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text("Déconnecter"),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ---------------------------------------------------------
          // HEADER
          // ---------------------------------------------------------
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text(
              "Bienvenue",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text(
              "MesseConnect",
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.church, size: 40, color: AppColors.primary),
            ),
          ),

          // ---------------------------------------------------------
          // PAROISSES
          // ---------------------------------------------------------
          _sectionTitle("Paroisses"),

          _item(
            icon: Icons.location_city_rounded,
            label: "Liste des paroisses",
            onTap: () {
              Get.back();
              Get.toNamed(Routes.parishes);
            },
          ),

          _item(
            icon: Icons.handshake_rounded,
            label: "À propos d’une paroisse",
            onTap: () {
              Get.back();
              Get.toNamed(Routes.parishDetails);
            },
          ),

          const Divider(),

          // ---------------------------------------------------------
          // APPLICATION
          // ---------------------------------------------------------
          _sectionTitle("Application"),

          _item(
            icon: Icons.info_outline_rounded,
            label: "À propos de MesseConnect",
            onTap: () => _openExternal("https://messeconnect.com/about"),
          ),

          _item(
            icon: Icons.privacy_tip_rounded,
            label: "Politique de confidentialité",
            onTap: () => _openExternal("https://messeconnect.com/privacy"),
          ),

          _item(
            icon: Icons.description_rounded,
            label: "Conditions d’utilisation",
            onTap: () => _openExternal("https://messeconnect.com/terms"),
          ),

          _item(
            icon: Icons.gavel_rounded,
            label: "Mentions légales",
            onTap: () => _openExternal("https://messeconnect.com/legal"),
          ),

          _item(
            icon: Icons.apps_rounded,
            label: "Version",
            trailing: const Text("v1.0.0"),
            onTap: () {},
          ),

          const Divider(),

          // ---------------------------------------------------------
          // DÉCONNEXION
          // ---------------------------------------------------------
          _item(
            icon: Icons.logout_rounded,
            label: "Se déconnecter",
            color: Colors.red,
            onTap: () {
              Get.back();
              _confirmLogout(); // nettoie token + redirection
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // UI HELPERS
  // ----------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary2,
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary2),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary2,
          fontSize: 15,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
