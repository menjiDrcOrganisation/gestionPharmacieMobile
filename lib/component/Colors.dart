import 'package:flutter/material.dart';

class MyColors {
  // Couleurs principales

  static const Color primary = Color(0xFF28A745); // bleu nuit
  static const Color secondary = Color(0xFFFBBF24); // jaune/or

  // Couleurs de fond
  static const Color background = Color(0xFFF5F5F5);
  static const Color scaffoldBackground = Colors.white;

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Couleurs des boutons
  static const Color buttonBackground = primary;
  static const Color buttonText = Colors.white;

  // Couleurs d'erreur
  static const Color error = Color(0xFFDC2626);

  // Exemple d’utilisation de gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
