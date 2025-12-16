import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ---------------------------------------------------------------------------
  // POPUP DE DECONNEXION
  // ---------------------------------------------------------------------------
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // -----------------------------------------------------------------
          // HEADER UTILISATEUR
          // -----------------------------------------------------------------
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.navInactive,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Nom Utilisateur",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "email@example.com",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // -----------------------------------------------------------------
          // SECTION : PARAMÈTRES DU COMPTE
          // -----------------------------------------------------------------
          const Text(
            "Compte",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.edit_rounded,
            title: "Modifier le profil",
            onTap: () {},
          ),

          _tile(
            icon: Icons.lock_rounded,
            title: "Changer le mot de passe",
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // -----------------------------------------------------------------
          // SECTION : PRÉFÉRENCES
          // -----------------------------------------------------------------
          const Text(
            "Préférences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.notifications_active_rounded,
            title: "Notifications",
            onTap: () => context.push("/notifications"),
          ),

          _tile(
            icon: Icons.language_rounded,
            title: "Langue de l’application",
            onTap: () {},
          ),

          _tile(
            icon: Icons.dark_mode_rounded,
            title: "Mode sombre (bientôt disponible)",
            onTap: () {},
          ),

          const SizedBox(height: 40),

          // -----------------------------------------------------------------
          // SECTION : DECONNEXION
          // -----------------------------------------------------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => _confirmLogout(context),
              label: const Text(
                "Déconnexion",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TILE REUSABLE
  // ---------------------------------------------------------------------------
  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary2, size: 26),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
