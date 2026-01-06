import 'package:get/get.dart';

// Transitions
import 'package:messeconnect/app/transition/transitions.dart';
import '../transition/blur_transition.dart';
import '../transition/soft_slide_transition.dart';


// Layouts
import 'package:messeconnect/layouts/auth_layout.dart';
import 'package:messeconnect/layouts/mass_layout.dart';
import 'package:messeconnect/features/navigation/main_navigation.dart';

// Pages Auth
import 'package:messeconnect/features/splash/splash_page.dart';
import 'package:messeconnect/features/onboarding/onboarding_page.dart';
import 'package:messeconnect/features/auth/pages/login_page.dart';
import 'package:messeconnect/features/auth/pages/register_page.dart';

// Pages principales
import 'package:messeconnect/features/home/pages/home_page.dart';
import 'package:messeconnect/features/profile/pages/profile_page.dart';
import 'package:messeconnect/features/support/pages/support_page.dart';
import 'package:messeconnect/features/payments/pages/payment_history_page.dart';

// Masses & réservations
import 'package:messeconnect/features/masses/pages/mass_detail_base_page.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservations_list_page.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservation_detail_page.dart';
import 'package:messeconnect/features/masses/models/mock_masses.dart';
import 'package:messeconnect/features/masses/models/reservation_model.dart';
import 'package:messeconnect/features/masses/bindings/mass_binding.dart';

// Paiement
import 'package:messeconnect/features/payments/pages/payment_form_page.dart';

// Drawer / static
import 'package:messeconnect/features/parish/pages/parishes_page.dart';
import 'package:messeconnect/features/parish/pages/parish_details_page.dart';
import 'package:messeconnect/features/static/pages/about_page.dart';
import 'package:messeconnect/features/static/pages/privacy_page.dart';
import 'package:messeconnect/features/static/pages/terms_page.dart';
import 'package:messeconnect/features/static/pages/legal_page.dart';

// Notifications
import 'package:messeconnect/features/notifications/pages/notifications_page.dart';

import '../middlewares/auth_middleware.dart';
import 'routes.dart';

class AppRouter {
  static final routes = [


    // =====================================================
    // AUTH
    // =====================================================

    GetPage(
      name: Routes.splash,
      page: () => AuthLayout(child: const SplashPage()),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => AuthLayout(child: const OnboardingPage()),
    ),
    GetPage(
      name: Routes.login,
      page: () => AuthLayout(child: const LoginPage()),
    ),
    GetPage(
      name: Routes.register,
      page: () => AuthLayout(child: const RegisterPage()),
    ),


    // =====================================================
    // MAIN NAVIGATION
    // =====================================================

    // Routes protégées-
    GetPage(
      name: Routes.home,
      page: () => MainNavigation(content: const HomePage()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.profile,
      page: () => MainNavigation(content: ProfilePage()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.reservations,
      page: () => const ReservationsListPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.payments,
      page: () => MainNavigation(content: const PaymentHistoryPage()),
    ),
    GetPage(
      name: Routes.support,
      page: () => MainNavigation(content: const SupportPage()),
    ),
    GetPage(
      name: Routes.reservationDetail,
      page: () {
        final reservation = Get.arguments as ReservationModel;
        return ReservationDetailPage(reservation: reservation);
      },
      customTransition: BlurTransition(),
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.parishes,
      page: () => const ParishesPage(),
    ),
    GetPage(
      name: Routes.parishDetails,
      page: () => const ParishDetailsPage(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutPage(),
    ),
    GetPage(
      name: Routes.privacy,
      page: () => const PrivacyPage(),
    ),
    GetPage(
      name: Routes.terms,
      page: () => const TermsPage(),
    ),
    GetPage(
      name: Routes.legal,
      page: () => const LegalPage(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsPage(),
      customTransition: MassTransition(),
      transitionDuration: const Duration(milliseconds: 200),
    ),



    // =====================================================
    // MASS FLOW
    // =====================================================
    GetPage(
      name: Routes.massDetail,
      page: () {
        final id = Get.parameters['id'];
        final mass = mockMasses.firstWhereOrNull((m) => m.id == id);

        if (mass == null) {
          return MainNavigation(content: const HomePage());
        }

        return MassLayout(
          child: MassDetailBasePage.forMass(mass),
        );
      },
      binding: MassBinding(),        // 🔹 binding centralisé
      middlewares: [AuthMiddleware()],
      customTransition: MassTransition(), // 🔹 transition conservée
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.payment,
      page: () => const PaymentFormPage(),
    ),

  ];
}
