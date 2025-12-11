import 'package:flutter/material.dart';

class ParishesPage extends StatelessWidget {
  const ParishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parishes = [
      {"name": "Paroisse Saint Michel", "city": "Libreville"},
      {"name": "Paroisse Notre Dame", "city": "Owendo"},
      {"name": "Paroisse Sainte Marie", "city": "Mindoubé"},
      {"name": "Paroisse Sacré Coeur", "city": "Akanda"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
        const Text("Paroisses", style: TextStyle(color: Colors.black)),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: parishes.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final p = parishes[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.red.shade100,
              child: Icon(Icons.church, color: Colors.red.shade400),
            ),
            title: Text(p["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(p["city"]!),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.pushNamed(context, "/parish-details"),
          );
        },
      ),
    );
  }
}
