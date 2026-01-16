// lib/features/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/service_card.dart';
import 'package:messeconnect/features/masses/models/mass_model.dart';
import 'package:messeconnect/features/masses/services/mass_service.dart';
import 'package:messeconnect/app/router/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -----------------------------------------------------------
  // 🔹 HEADER
  // -----------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        const Text(
          "MesseConnect",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 26,
          ),
          onPressed: () => Get.toNamed(Routes.notifications),
        ),
        const SizedBox(height: 6),
        /*Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      "Rechercher une messe...",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => Get.toNamed(Routes.notifications),
            ),
          ],
        )*/
      ],
    );
  }

  // -------------------------------------------------------------------
  // BUILD
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: size.height * 0.03),
              Expanded(
                child: FutureBuilder<List<MassModel>>(
                  future: MassService.fetchMasses(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child:
                        CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final masses = snapshot.data!;

                    return GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      children: masses.map((m) {
                        return ServiceCard(
                            key: ValueKey("card_${m.id}"),
                            title: m.title,
                            heroTag: m.heroTag,
                            imageAsset: m.imageAsset,
                            borderColor: m.accentColor,
                            onTap: () {
                              Get.toNamed(
                                Routes.massDetail.replaceFirst(':id', m.id),
                              );
                            }

                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () =>
                      Get.toNamed(Routes.reservations),
                  child: Text(
                    'Voir mes réservations',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
