// lib/app/router/app_router.dart

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

// Pages Home
import 'package:messeconnect/features/home/pages/home_page.dart';
import 'package:messeconnect/features/masses/pages/reservations_list_page.dart';

// Pages Messes
import 'package:messeconnect/features/masses/pages/nuptial_mass_page.dart';
import 'package:messeconnect/features/masses/pages/healing_mass_page.dart';
import 'package:messeconnect/features/masses/pages/thanksgiving_mass_page.dart';
import 'package:messeconnect/features/masses/pages/requiem_mass_page.dart';

import '../../features/masses/models/reservation_model.dart';
import '../../features/masses/pages/reservation_detail_page.dart';
import '../../features/navigation/main_navigation.dart';
import '../../features/payments/pages/payment_choice_page.dart';
import '../../features/payments/pages/payment_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/support/pages/support_page.dart';

final _rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/splash',

    routes: [

      // --------------------------
      // 1. AUTH LAYOUT (avec gradient)
      // --------------------------
      ShellRoute(
        builder: (_, __, child) => AuthLayout(child: child),
        routes: [
          GoRoute(
            path: '/splash',
            builder: (_, __) => const SplashPage(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (_, __) => const OnboardingPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) => const LoginPage(),
          ),
          GoRoute(
            path: '/register',
            builder: (_, __) => const RegisterPage(),
          ),
        ],
      ),

      // --------------------------
      // 2. HOME LAYOUT (avec gradient)
      // --------------------------
      ShellRoute(
        builder: (_, __, child) => MainNavigation(content: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/payments', builder: (_, __) => const PaymentPage()),
          GoRoute(path: '/support', builder: (_, __) => const SupportPage()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),

          GoRoute(
            path: '/reservations',
            builder: (_, __) => const ReservationsListPage(),
          ),

          GoRoute(
            path: '/reservation-detail',
            builder: (_, state) {
              final r = state.extra as ReservationModel;
              return ReservationDetailPage(reservation: r);
            },
          ),
        ],
      ),



      // --------------------------
      // 3. MASS LAYOUT (sans gradient)
      // --------------------------
      ShellRoute(
        builder: (_, __, child) => MassLayout(child: child),
        routes: [
          GoRoute(
            path: '/mass/nuptiale',
            pageBuilder: (_, state) => massTransition(
              child: const NuptialMassPage(),
            ),
          ),
          GoRoute(
            path: '/mass/guerison',
            pageBuilder: (_, state) => massTransition(
              child: const HealingMassPage(),
            ),
          ),
          GoRoute(
            path: '/mass/action-grace',
            pageBuilder: (_, state) => massTransition(
              child: const ThanksgivingMassPage(),
            ),
          ),
          GoRoute(
            path: '/mass/requiem',
            pageBuilder: (_, state) => massTransition(
              child: const RequiemMassPage(),
            ),
          ),

          //Payment
          GoRoute(
            path: '/payment',
            builder: (_, __) => const PaymentChoicePage(),
          ),


        ],
      ),
    ],
  );
}
