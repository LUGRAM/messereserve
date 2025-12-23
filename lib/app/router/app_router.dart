import 'package:get/get.dart';

// Routes names
import '../../features/navigation/main_navigation.dart';
import 'routes.dart';

// Layouts
import 'package:messeconnect/layouts/auth_layout.dart';

// Auth Pages
import 'package:messeconnect/features/splash/splash_page.dart';
import 'package:messeconnect/features/onboarding/onboarding_page.dart';
import 'package:messeconnect/features/auth/pages/login_page.dart';
import 'package:messeconnect/features/auth/pages/register_page.dart';
// Home Pages
import 'package:messeconnect/features/home/pages/home_page.dart';
import 'package:messeconnect/features/profile/pages/profile_page.dart';
import 'package:messeconnect/features/support/pages/support_page.dart';

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
  ];
}
