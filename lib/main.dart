// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messeconnect/app/router/app_router.dart';
import 'package:messeconnect/app/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MesseConnectApp()));
}

class MesseConnectApp extends StatelessWidget {
  const MesseConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MesseConnect',
      theme: AppTheme.light(),
      routerConfig: AppRouter.router,
    );
  }
}
