import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../parish/controllers/pastor_controller.dart';

class PastorSelector extends StatelessWidget {
  const PastorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final PastorController ctrl = Get.find();

    return SizedBox(
      height: 400,
      child: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.pastors.isEmpty) {
          return const Center(child: Text("Aucun prêtre trouvé"));
        }

        return ListView.builder(
          itemCount: ctrl.pastors.length,
          itemBuilder: (_, i) {
            final pastor = ctrl.pastors[i];
            return ListTile(
              title: Text(pastor.nom),
              subtitle: Text(pastor.telephone),
              trailing: const Icon(FontAwesomeIcons.userTie),
              onTap: () => Navigator.pop(context, pastor),
            );
          },
        );
      }),
    );
  }
}
