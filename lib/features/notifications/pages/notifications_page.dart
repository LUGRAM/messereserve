import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ fond blanc permanent

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 18,
          ),
            onPressed: () => Get.back(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        children: [
          _notificationItem(
            icon: Icons.notifications_active_rounded,
            iconBg: const Color(0xFFFFE5E5),
            iconColor: Colors.redAccent,
            title: "Votre demande de messe a été approuvée",
            date: "Aujourd’hui · 10:24",
            isUnread: true,
          ),

          _divider(),

          _notificationItem(
            icon: Icons.payment_rounded,
            iconBg: const Color(0xFFE6F4EA),
            iconColor: Colors.green,
            title: "Votre paiement a été confirmé",
            date: "Hier · 18:12",
          ),

          _divider(),

          _notificationItem(
            icon: Icons.church_rounded,
            iconBg: const Color(0xFFEAF0FF),
            iconColor: Colors.blueAccent,
            title: "Nouvelle annonce paroissiale",
            date: "Hier · 08:55",
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGETS
  // ---------------------------------------------------------------------------

  Widget _notificationItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String date,
    bool isUnread = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 14),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    isUnread ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Badge non lu
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 6),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.6,
      indent: 74,
      endIndent: 16,
    );
  }
}
