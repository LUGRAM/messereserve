import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../app/theme/app_colors.dart';

class NeoPhoneField extends StatelessWidget {
  final String? phoneValue;
  final void Function(String)? onChanged;

  const NeoPhoneField({
    super.key,
    this.phoneValue,
    this.onChanged,
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
      child: IntlPhoneField(
        // 🇬🇦 GABON FIXE
        initialValue: phoneVal?.replaceFirst('+241', ''),
        initialCountryCode: 'GA',

        showDropdownIcon: true,
        showCountryFlag: true,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],

        keyboardType: TextInputType.phone,

        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: false,
          fillColor: Colors.transparent,
          hintText: "Numéro de téléphone",
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
          ),
          counterText: '',
          errorStyle: TextStyle(height: 0),
        ),

        style: const TextStyle(
          color: AppColors.textPrimary2,
          fontSize: 15,
        ),

        dropdownTextStyle: const TextStyle(
          color: AppColors.textPrimary2,
          fontWeight: FontWeight.w500,
        ),

        onChanged: (phone) {
          phoneVal = phone.completeNumber;
          if (onChanged != null) {
            onChanged!(phoneVal!);
          }
        },

        validator: (value) =>
        value == null || value.number.isEmpty
            ? 'Numéro requis'
            : null,
      ),
    );
  }
}
