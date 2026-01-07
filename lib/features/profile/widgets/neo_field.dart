import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';

class NeoField extends StatelessWidget {
  final Widget child;
  final IconData icon;

  const NeoField({
    super.key,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          // lumière douce (haut gauche)
          BoxShadow(
            color: Colors.white.withValues(alpha:0.75),
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
          // ombre subtile (bas droite)
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.9),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.iconInactive,
          ),
          const SizedBox(width: 12),

          // Champ injecté (TextFormField / IntlPhoneField)
          Expanded(
            child: Theme(
              // On verrouille TOUTES les couleurs parasites (rouge Flutter)
              data: Theme.of(Get.context!).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: TextStyle(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
