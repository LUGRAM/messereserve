import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/service_card.dart';
import 'package:messeconnect/features/masses/mass_navigation.dart';
import 'package:messeconnect/features/masses/models/mass_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // -----------------------------------------------------------
  // 🔹 HEADER COMPLET : MesseConnect + Menu + Search + Notifs
  // -----------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ──────────────── TITRE ────────────────
        const Text(
          "MesseConnect",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // ──────────────── ROW → MENU + SEARCH + NOTIFS ────────────────
        Row(
          children: [

            // ----- MENU (Drawer) -----
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),

            const SizedBox(width: 6),

            // ----- SEARCH BAR -----
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Plus tard → route vers search
                  // context.push("/search");
                },
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
            ),

            const SizedBox(width: 10),

            // ----- NOTIFICATIONS -----
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {
                // context.push("/notifications");
              },
            ),
          ],
        )
      ],
    );
  }

  // -------------------------------------------------------------------
  // PAGE BUILD
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

              // 🔹 HEADER (NOUVEAU)
              _buildHeader(context),
              SizedBox(height: size.height * 0.03),

              // 🔹 GRID DES SERVICES
              Expanded(
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: [

                    ServiceCard(
                      key: const ValueKey("card_messe_requiem"),
                      title: 'Messe De Requiem',
                      heroTag: 'messe_requiem',
                      imageAsset: 'assets/images/masses/requiem.jpg',
                      borderColor: Colors.lightBlue,
                      onTap: () =>
                          navigateToMass(context, MassType.requiem),
                    ),

                    ServiceCard(
                      key: const ValueKey("card_messe_action_grace"),
                      title: "Messe D' Action De Grâce",
                      heroTag: 'messe_action_grace',
                      imageAsset:
                      'assets/images/masses/action_grace.jpg',
                      borderColor: Colors.redAccent,
                      onTap: () =>
                          navigateToMass(context, MassType.actionGrace),
                    ),

                    ServiceCard(
                      key: const ValueKey("card_messe_guerison"),
                      title: 'Messe Pour La Santé Et La Guérison',
                      heroTag: 'messe_guerison',
                      imageAsset: 'assets/images/masses/guerison.jpg',
                      borderColor: Colors.green,
                      onTap: () =>
                          navigateToMass(context, MassType.guerison),
                    ),

                    ServiceCard(
                      key: const ValueKey("card_messe_nuptiale"),
                      title: 'Messe Nuptiale',
                      heroTag: 'messe_nuptiale',
                      imageAsset: 'assets/images/masses/nuptial.jpg',
                      borderColor: Colors.blueAccent,
                      onTap: () =>
                          navigateToMass(context, MassType.nuptial),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 BOUTON "Voir mes réservations"
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => context.push('/reservations'),
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
