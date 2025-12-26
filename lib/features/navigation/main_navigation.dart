import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messeconnect/app/theme/app_colors.dart';

import '../../app/router/routes.dart';
import '../../layouts/drawer/app_drawer.dart';

class MainNavigation extends StatefulWidget {
  final Widget content;

  const MainNavigation({super.key, required this.content});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  // 🔹 Mapping route -> index
  int _indexFromRoute(String route) {
    if (route.startsWith(Routes.home)) return 0;
    if (route.startsWith(Routes.payments)) return 1;
    if (route.startsWith(Routes.support)) return 2;
    if (route.startsWith(Routes.profile)) return 3;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = _indexFromRoute(Get.currentRoute);
  }

  void _onTap(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.home);
        break;
      case 1:
        Get.offAllNamed(Routes.payments);
        break;
      case 2:
        Get.offAllNamed(Routes.support);
        break;
      case 3:
        Get.offAllNamed(Routes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: widget.content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.navBackground,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_rounded),
            label: "Paiement",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_rounded),
            label: "Support",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
