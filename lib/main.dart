// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/binding/auth_binding.dart';
import 'app/router/app_router.dart';
import 'app/router/routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du storage GetX
  await GetStorage.init();
  runApp(const MesseConnectApp());
}

class MesseConnectApp extends StatelessWidget {
  const MesseConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MesseConnect',

      theme: AppTheme.light(),

      initialRoute: Routes.splash,
      getPages: AppRouter.routes,

      initialBinding: AuthBinding(),

      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
    );

  }
}
