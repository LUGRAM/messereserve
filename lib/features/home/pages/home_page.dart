import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/service_card.dart';
import 'package:messeconnect/features/masses/models/mass_model.dart';
import 'package:messeconnect/features/masses/services/mass_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<MassModel>> _massesFuture;

  @override
  void initState() {
    super.initState();
    _massesFuture = MassService.fetchMasses();
  }

  // -----------------------------------------------------------
  // 🔹 HEADER : titre + menu + search + notifications
  // -----------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "MesseConnect",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: [

            // MENU (Drawer)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),

            const SizedBox(width: 6),

            // SEARCH (placeholder)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // À valider avec le tuteur
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

            // NOTIFICATIONS
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => context.push("/notifications"),
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

              _buildHeader(context),
              SizedBox(height: size.height * 0.03),

              // 🔹 GRID DYNAMIQUE DES MESSES
              Expanded(
                child: FutureBuilder<List<MassModel>>(
                  future: _massesFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
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
                          imageAsset: m.image,
                          borderColor: Color(m.accentColor),
                          onTap: () => context.push(m.route),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 BOUTON RÉSERVATIONS
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
