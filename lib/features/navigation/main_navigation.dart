import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/theme/app_colors.dart';

import '../../layouts/drawer/app_drawer.dart';

class MainNavigation extends StatefulWidget {
  final Widget content;

  const MainNavigation({super.key, required this.content});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),   // ← AJOUT OBLIGATOIRE ICI
      body: widget.content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.navBackground,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() => _currentIndex = i);
          switch (i) {
            case 0: context.go('/home'); break;
            case 1: context.go('/payments'); break;
            case 2: context.go('/support'); break;
            case 3: context.go('/profile'); break;
          }
        },
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
