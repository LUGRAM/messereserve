// lib/features/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), _handleNavigation);
  }

  void _handleNavigation() {
    final bool hasSeenOnboarding =
        _storage.read('hasSeenOnboarding') ?? false;

    final String? token = _storage.read('auth_token');

    if (!hasSeenOnboarding) {
      Get.offAllNamed(Routes.onboarding);
    } else if (token == null || token.isEmpty) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width * 0.25,
                height: size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.church,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'MesseConnect',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'réserver vos messes sans vous déplacer',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary1.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
