// lib/features/masses/widgets/pastor_selector.dart

import 'package:flutter/material.dart';
import 'package:messeconnect/features/masses/models/mock_pastors.dart';


class PastorSelector extends StatelessWidget {
  const PastorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Choisir un pasteur",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: mockPastors.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final p = mockPastors[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(p.image),
                    ),
                    title: Text(p.name),
                    subtitle: p.phone != null
                        ? Text("Tel : ${p.phone}")
                        : null,
                    onTap: () => Navigator.pop(context, p),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
