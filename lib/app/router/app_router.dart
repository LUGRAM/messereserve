import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/router/transitions.dart';

// Layouts
import 'package:messeconnect/layouts/auth_layout.dart';
import 'package:messeconnect/layouts/mass_layout.dart';

// Pages Auth
import 'package:messeconnect/features/splash/splash_page.dart';
import 'package:messeconnect/features/onboarding/onboarding_page.dart';
import 'package:messeconnect/features/auth/pages/login_page.dart';
import 'package:messeconnect/features/auth/pages/register_page.dart';

// Pages principales
import 'package:messeconnect/features/home/pages/home_page.dart';
import 'package:messeconnect/features/navigation/main_navigation.dart';

// Masses
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservations_list_page.dart';
import 'package:messeconnect/features/masses/models/mass_model.dart';
import 'package:messeconnect/features/masses/models/mock_masses.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservation_detail_page.dart';

// Paiements (nouveaux noms de fichiers)
import 'package:messeconnect/features/payments/pages/payment_form_page.dart';
import 'package:messeconnect/features/payments/pages/payment_history_page.dart';

// Profil & Support
import 'package:messeconnect/features/profile/pages/profile_page.dart';
import 'package:messeconnect/features/support/pages/support_page.dart';

// Drawer pages
import 'package:messeconnect/features/parish/pages/parishes_page.dart';
import 'package:messeconnect/features/parish/pages/parish_details_page.dart';
import 'package:messeconnect/features/static/pages/about_page.dart';
import 'package:messeconnect/features/static/pages/privacy_page.dart';
import 'package:messeconnect/features/static/pages/terms_page.dart';
import 'package:messeconnect/features/static/pages/legal_page.dart';

// Notifications
import 'package:messeconnect/features/notifications/pages/notifications_page.dart';

import '../../features/payments/pages/payment_form_page.dart';

final _rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/splash',
    routes: [
      // =========================================================
      // 1. AUTH LAYOUT
      // =========================================================
      ShellRoute(
        builder: (_, __, child) => AuthLayout(child: child),
        routes: [
          GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
          GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
          GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
          GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
        ],
      ),

      // =========================================================
      // 2. MAIN NAVIGATION (Home + Drawer + BottomNav)
      // =========================================================
      ShellRoute(
        builder: (_, __, child) => MainNavigation(content: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/payments', builder: (_, __) => const PaymentHistoryPage()),
          GoRoute(path: '/support', builder: (_, __) => const SupportPage()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),

          GoRoute(path: '/reservations', builder: (_, __) => const ReservationsListPage()),

          GoRoute(
            path: '/reservation-detail',
            builder: (_, state) {
              final reservation = state.extra as ReservationModel;
              return ReservationDetailPage(reservation: reservation);
            },
          ),

          GoRoute(path: '/parishes', builder: (_, __) => const ParishesPage()),
          GoRoute(path: '/parish-details', builder: (_, __) => const ParishDetailsPage()),

          GoRoute(path: '/about', builder: (_, __) => const AboutPage()),
          GoRoute(path: '/privacy', builder: (_, __) => const PrivacyPage()),
          GoRoute(path: '/terms', builder: (_, __) => const TermsPage()),
          GoRoute(path: '/legal', builder: (_, __) => const LegalPage()),

          GoRoute(path: '/notifications', builder: (_, __) => const NotificationsPage()),
        ],
      ),

      // =========================================================
      // 3. MASS LAYOUT (Flux messe + paiement)
      // =========================================================
      ShellRoute(
        builder: (_, __, child) => MassLayout(child: child),
        routes: [
          GoRoute(
            path: '/mass/:id',
            pageBuilder: (_, state) {
              final id = state.pathParameters['id']!;
              final MassModel? mass = state.extra as MassModel? ??
                  mockMasses.where((m) => m.id == id).cast<MassModel?>().firstOrNull;

              if (mass == null) {
                return const NoTransitionPage(child: HomePage());
              }

              return massTransition(
                child: MassDetailBasePage.forMass(mass),
              );
            },
          ),

          // Nouvelle route unique de paiement
          GoRoute(path: '/payment', builder: (_, __) => const PaymentFormPage()),
        ],
      ),
    ],
  );
}
