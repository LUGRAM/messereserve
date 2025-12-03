// lib/features/home/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/service_card.dart';
//
import 'package:messeconnect/features/masses/mass_navigation.dart';
import 'package:messeconnect/features/masses/models/mass_type.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Text(
                  'MesseConnect',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  'Paroisse IT-Master',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: size.height * 0.04),
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
                        onTap: () => navigateToMass(context, MassType.requiem),
                      ),

                      ServiceCard(
                        key: const ValueKey("card_messe_action_grace"),
                        title: "Messe D' Action De Grâce",
                        heroTag: 'messe_action_grace',
                        imageAsset: 'assets/images/masses/action_grace.jpg',
                        borderColor: Colors.redAccent,
                        onTap: () => navigateToMass(context, MassType.actionGrace),
                      ),
                      ServiceCard(
                        key: const ValueKey("card_messe_guerison"),
                        title: 'Messe Pour La Santé Et La Guérison',
                        heroTag: 'messe_guerison',
                        imageAsset: 'assets/images/masses/guerison.jpg',
                        borderColor: Colors.green,
                        onTap: () => navigateToMass(context, MassType.guerison),
                      ),
                      ServiceCard(
                        key: const ValueKey("card_messe_nuptiale"),
                        title: 'Messe Nuptiale',
                        heroTag: 'messe_nuptiale',
                        imageAsset: 'assets/images/masses/nuptial.jpg',
                        borderColor: Colors.blueAccent,
                        onTap: () => navigateToMass(context, MassType.nuptial),
                      ),
                      // Paramètres / Profil : tu peux les garder comme avant ou les adapter
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
      ),
    );
  }
}
