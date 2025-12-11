import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Notifications", style: TextStyle(color: Colors.black)),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _notifTile(
            icon: Icons.notifications_active_rounded,
            iconColor: Colors.red,
            title: "Votre demande de messe a été approuvée",
            date: "Aujourd’hui • 10:24",
          ),
          const Divider(),

          _notifTile(
            icon: Icons.payment_rounded,
            iconColor: Colors.green,
            title: "Votre paiement a été confirmé",
            date: "Hier • 18:12",
          ),
          const Divider(),

          _notifTile(
            icon: Icons.church_rounded,
            iconColor: Colors.blueAccent,
            title: "Nouvelle annonce paroissiale",
            date: "Hier • 08:55",
          ),
        ],
      ),
    );
  }

  Widget _notifTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String date,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: iconColor.withOpacity(.15),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(date),
    );
  }
}
