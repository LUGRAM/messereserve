import 'package:flutter/material.dart';

class AppColors {
  // ---------------------------------------------------------------------------
  // 🎨 IDENTITÉ VISUELLE PRINCIPALE — PALETTE MODERNE
  // ---------------------------------------------------------------------------

  static const Color primary = Color(0xFF1BC6C5);
  static const Color primaryDark = Color(0xFF0E9998);
  static const Color accent = Color(0xFF16A7CE);

  // ---------------------------------------------------------------------------
  // 🧱 UI GÉNÉRIQUE
  // ---------------------------------------------------------------------------

  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFF1F1F1);
  static const Color border = Color(0xFFE1E1E1);

  static const Color iconInactive = Color(0xFFBDBDBD);

  static const Color textPrimary = Color(0xFF152025);
  static const Color textSecondary = Color(0xFF5B6A75);

  // -------------------- INPUTS (TextFields)
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocused = Color(0xFF1BC6C5);
  static const Color inputHint = Color(0xFF9E9E9E);
  static const Color inputText = Color(0xFF152025);

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  static const Color navBackground = Color(0xFFF1F1F1);
  static const Color navActive = Color(0xFF1BC6C5);
  static const Color navInactive = Color(0xFFBDBDBD);

  // ---------------------------------------------------------------------------
  // 🔥 MESSAGES — DÉGRADÉS LITURGIQUES
  // ---------------------------------------------------------------------------

  static const Color massRedTop = Color(0xFFD32F2F);
  static const Color massRedBottom = Color(0xFFB71C1C);

  // ---------------------------------------------------------------------------
  // ⚠️ ÉTATS / ALERTES
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color danger = Color(0xFFE53935);

  // ---------------------------------------------------------------------------
  // ✨ TRANSPARENCE / GLASSMORPHISM
  // ---------------------------------------------------------------------------

  static const Color whiteOpacity20 = Color.fromARGB(50, 255, 255, 255);
  static const Color whiteOpacity40 = Color.fromARGB(100, 255, 255, 255);

  // ---------------------------------------------------------------------------
  // 🟪 LEGACY (Anciennes couleurs — pages Auth)
  // ---------------------------------------------------------------------------

  static const Color legacyGradientTop = Color(0xFF7A3B51);
  static const Color legacyGradientBottom = Color(0xFFE63A5A);

  static const Color legacyButtonStart = Color(0xFFF9415C);
  static const Color legacyButtonEnd = Color(0xFFF84D4D);

  static const Color legacyCardPink = Color(0xFFF77A8F);
  static const Color legacyInputHint = Colors.white70;

  static const Color legacyTextPrimary = Colors.white;
  static const Color legacyTextYellow = Color(0xFFF8D66D);

  // ---------------------------------------------------------------------------
  // 🔄 COMPATIBILITÉ ANCIENS NOMS
  // ---------------------------------------------------------------------------

  static const Color inputBg = inputBackground;        // ancien nom

  static const Color gradientTop = legacyGradientTop;  // ancien nom
  static const Color gradientBottom = legacyGradientBottom;

  static const Color buttonStart = legacyButtonStart;  // ancien nom
  static const Color buttonEnd = legacyButtonEnd;

  static const Color cardPink = legacyCardPink;        // ancien nom

  static const Color textYellow = legacyTextYellow;    // ancien nom
}
