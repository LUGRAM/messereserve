import 'package:flutter/material.dart';
import 'package:messeconnect/app/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,

      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // ---------------------------------------------------------
          // 🔹 HEADER
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
          // 🔹 SECTION : PAROISSES
          // ---------------------------------------------------------
          _sectionTitle("Paroisses"),

          _item(
            icon: Icons.location_city_rounded,
            label: "Liste des paroisses",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/parishes");
            },
          ),

          _item(
            icon: Icons.handshake_rounded,
            label: "À propos d’une paroisse",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/parish-details");
            },
          ),

          const Divider(),

          // ---------------------------------------------------------
          // 🔹 SECTION : APPLICATION
          // ---------------------------------------------------------
          _sectionTitle("Application"),

          _item(
            icon: Icons.info_outline_rounded,
            label: "À propos de MesseConnect",
            onTap: () {},
          ),

          _item(
            icon: Icons.privacy_tip_rounded,
            label: "Politique de confidentialité",
            onTap: () {},
          ),

          _item(
            icon: Icons.description_rounded,
            label: "Conditions d’utilisation",
            onTap: () {},
          ),

          _item(
            icon: Icons.gavel_rounded,
            label: "Mentions légales",
            onTap: () {},
          ),

          _item(
            icon: Icons.apps_rounded,
            label: "Version",
            trailing: const Text("v1.0.0"),
            onTap: () {},
          ),

          const Divider(),

          // ---------------------------------------------------------
          // 🔹 DECONNEXION
          // ---------------------------------------------------------
          _item(
            icon: Icons.logout_rounded,
            label: "Se déconnecter",
            color: Colors.red,
            onTap: () {},
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
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
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
