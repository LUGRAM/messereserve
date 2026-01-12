import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messeconnect/app/theme/app_colors.dart';

import '../models/info_site.dart';
import '../services/info_site_service.dart';
import 'confidentialite_page.dart';

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
      body: FutureBuilder<InfoSite?>(
        future: InfoSiteService.fetchInfoSite(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Impossible de charger les informations"));
          }

          final info = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ------------------------------------------------------------
              // 🔹 SUPPORT DIRECT
              // ------------------------------------------------------------
              const Text(
                "Assistance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),

              if (info.whatsapp != null)
                _tile(
                  icon: FontAwesomeIcons.whatsapp,
                  title: "Assistance WhatsApp",
                  subtitle: info.whatsapp!,
                  onTap: () => _open("https://wa.me/${info.whatsapp!.replaceAll('+', '')}"),
                ),

              if (info.email != null)
                _tile(
                  icon: Icons.email_rounded,
                  title: "Email support",
                  subtitle: info.email!,
                  onTap: () => _open("mailto:${info.email}"),
                ),

              if (info.telephone != null)
                _tile(
                  icon: Icons.phone_in_talk_rounded,
                  title: "Appeler le support",
                  subtitle: info.telephone!,
                  onTap: () => _open("tel:${info.telephone}"),
                ),

              const SizedBox(height: 30),

              // ------------------------------------------------------------
              // 🔹 CONFIDENTIALITÉ
              // ------------------------------------------------------------
              const Text(
                "Confidentialité",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),

              _tile(
                icon: Icons.policy,
                title: "Politique de confidentialité",
                subtitle: "Consultez nos règles de protection des données",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfidentialitePage(
                        content: info.confidentialite ?? "",
                      ),
                    ),
                  );
                },
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
          );
        },
      ),
    );
  }

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
          child: Icon(icon, color: AppColors.textPrimary2),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
