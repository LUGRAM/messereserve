// lib/features/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';

import '../../app/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      title: 'Réservez vos messes',
      subtitle: 'Choisissez facilement le type de messe\nsans vous déplacer.',
      icon: Icons.event_available,
    ),
    _OnboardData(
      title: 'Intention & bénéficiaire',
      subtitle: 'Indiquez vos intentions et les personnes\npour qui la messe est célébrée.',
      icon: Icons.favorite,
    ),
    _OnboardData(
      title: 'Paiement sécurisé',
      subtitle: 'Réglez vos offrandes en toute sécurité\nvia mobile ou carte.',
      icon: Icons.lock_outline,
    ),
  ];

  void _goNext() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // TODO: marquer onboarding vu dans SharedPreferences
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Passer', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final data = _pages[i];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              data.icon,
                              size: 70,
                              color: AppColors.gradientBottom,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _index == i ? 14 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == i ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goNext,
                    child: Text(_index == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardData {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
