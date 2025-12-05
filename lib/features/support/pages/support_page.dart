import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messeconnect/app/theme/app_colors.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Support"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ------------------------------------------------------------
          // 🔹 ASSISTANCE UTILISATEUR
          // ------------------------------------------------------------
          const Text(
            "Assistance utilisateur",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.help_center_rounded,
            title: "FAQ – Questions fréquentes",
            subtitle: "Réponses aux questions courantes",
            onTap: () {},
          ),

          _tile(
            icon: Icons.menu_book_rounded,
            title: "Guide d’utilisation",
            subtitle: "Tout savoir sur les réservations",
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // ------------------------------------------------------------
          // 🔹 SUPPORT DIRECT
          // ------------------------------------------------------------
          const Text(
            "Support direct",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: FontAwesomeIcons.whatsapp,
            title: "Assistance WhatsApp",
            subtitle: "+241 77 06 90 67",
            onTap: () => _open("https://wa.me/24177069067"),
          ),

          _tile(
            icon: Icons.email_rounded,
            title: "Email support",
            subtitle: "support@messeconnect.com",
            onTap: () => _open("mailto:support@messeconnect.com"),
          ),

          _tile(
            icon: Icons.phone_in_talk_rounded,
            title: "Appeler le support",
            subtitle: "+241 01 23 45 67",
            onTap: () => _open("tel:+24101234567"),
          ),

          const SizedBox(height: 30),

          // ------------------------------------------------------------
          // 🔹 SUPPORT TECHNIQUE
          // ------------------------------------------------------------
          const Text(
            "Support technique",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.bug_report_rounded,
            title: "Signaler un bug",
            subtitle: "Envoyer un rapport technique",
            onTap: () {},
          ),

          _tile(
            icon: Icons.code,
            title: "Assistance technique",
            subtitle: "tech@messeconnect.com",
            onTap: () => _open("mailto:tech@messeconnect.com"),
          ),

          _tile(
            icon: Icons.info_outline_rounded,
            title: "Version de l’application",
            subtitle: "v1.0.0",
            onTap: () {},
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "MesseConnect © ${DateTime.now().year}",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WIDGET DE TILE RÉUTILISABLE
  // ------------------------------------------------------------
  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.surface,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
