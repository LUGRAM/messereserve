import 'package:get/get.dart';

// Routes names
import '../../features/navigation/main_navigation.dart';
import 'routes.dart';

// Layouts
import 'package:messeconnect/layouts/auth_layout.dart';
import 'package:messeconnect/layouts/mass_layout.dart';

// Auth Pages
import 'package:messeconnect/features/splash/splash_page.dart';
import 'package:messeconnect/features/onboarding/onboarding_page.dart';
import 'package:messeconnect/features/auth/pages/login_page.dart';
import 'package:messeconnect/features/auth/pages/register_page.dart';

// Home Pages
import 'package:messeconnect/features/home/pages/home_page.dart';
import 'package:messeconnect/features/profile/pages/profile_page.dart';
import 'package:messeconnect/features/support/pages/support_page.dart';
import 'package:messeconnect/features/payments/pages/payment_page.dart';
import 'package:messeconnect/features/payments/pages/payment_choice_page.dart';

// Reservations
import 'package:messeconnect/features/masses/pages/reservations_list_page.dart';
import '../../features/masses/models/reservation_model.dart';
import '../../features/masses/pages/reservation_detail_page.dart';

// Masses Pages
import 'package:messeconnect/features/masses/pages/nuptial_mass_page.dart';
import 'package:messeconnect/features/masses/pages/healing_mass_page.dart';
import 'package:messeconnect/features/masses/pages/thanksgiving_mass_page.dart';
import 'package:messeconnect/features/masses/pages/requiem_mass_page.dart';

class AppRouter {
  static final routes = [

    // --------------------------
    // AUTH LAYOUT
    // --------------------------
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

    // --------------------------
    // HOME LAYOUT
    // --------------------------
    GetPage(
      name: Routes.home,
      page: () => MainNavigation(content: const HomePage()),
    ),
    GetPage(
      name: Routes.profile,
      page: () => MainNavigation(content: const ProfilePage()),
    ),
    GetPage(
      name: Routes.support,
      page: () => MainNavigation(content: const SupportPage()),
    ),
    GetPage(
      name: Routes.payments,
      page: () => MainNavigation(content: const PaymentPage()),
    ),

    GetPage(
      name: Routes.reservations,
      page: () => MainNavigation(content: const ReservationsListPage()),
    ),

    GetPage(
      name: Routes.reservationDetail,
      page: () {
        final reservation = Get.arguments as ReservationModel;
        return MainNavigation(
          content: ReservationDetailPage(reservation: reservation),
        );
      },
    ),

    // --------------------------
    // MASS LAYOUT
    // --------------------------
    GetPage(
      name: Routes.massNuptial,
      page: () => MassLayout(child: const NuptialMassPage()),
    ),
    GetPage(
      name: Routes.massHealing,
      page: () => MassLayout(child: const HealingMassPage()),
    ),
    GetPage(
      name: Routes.massThanksgiving,
      page: () => MassLayout(child: const ThanksgivingMassPage()),
    ),
    GetPage(
      name: Routes.massRequiem,
      page: () => MassLayout(child: const RequiemMassPage()),
    ),

    // Payment choice (avant paiement)
    GetPage(
      name: Routes.paymentChoice,
      page: () => MassLayout(child: const PaymentChoicePage()),
    ),
  ];
}
