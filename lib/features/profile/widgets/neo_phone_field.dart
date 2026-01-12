import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../app/theme/app_colors.dart';

class NeoPhoneField extends StatelessWidget {
  final String? phoneValue;
  final void Function(String)? onChanged;
  final bool enabled;

  const NeoPhoneField({
    super.key,
    this.phoneValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    String? phoneVal = phoneValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: AppColors.border,
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child:IntlPhoneField(
        initialValue: phoneValue?.replaceFirst('+241', ''),
        initialCountryCode: 'GA',

        enabled: enabled,                 // ⬅️ champ désactivé
        readOnly: !enabled,               // ⬅️ empêche le clavier
        showDropdownIcon: false,           // ⬅️ empêche changement pays
        disableLengthCheck: true,

        keyboardType: TextInputType.none,  // ⬅️ sécurité supplémentaire
        inputFormatters: enabled
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],

        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: false,
          hintText: "Numéro de téléphone",
          counterText: '',
        ),

        style: const TextStyle(
          color: AppColors.textPrimary2,
          fontSize: 15,
        ),

        dropdownTextStyle: const TextStyle(
          color: AppColors.textPrimary2,
          fontWeight: FontWeight.w500,
        ),

        onChanged: enabled
            ? (phone) {
          if (onChanged != null) {
            onChanged!(phone.completeNumber);
          }
        }
            : null,

        validator: null, // ⬅️ pas de validation si bloqué
      ),
    );
  }
}
