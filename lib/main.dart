// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:messeconnect/app/router/app_router.dart';
import 'package:messeconnect/app/theme/app_theme.dart';

import 'app/router/routes.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/home/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MesseConnectApp()));
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
    );
  }
}
