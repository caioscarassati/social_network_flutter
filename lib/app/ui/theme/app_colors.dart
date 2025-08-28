import 'package:flutter/material.dart';

// Classe para gerenciar as cores do aplicativo, garantindo consistência.
abstract class AppColors {
  static const Color primary = Color(0xFF007BFF); // Azul primário
  static const Color primaryDark = Color(0xFF0056b3);
  static const Color accent = Color(0xFF28A745);  // Verde para ações de sucesso

  static const Color background = Color(0xFFF4F6F8);
  static const Color card = Colors.white;

  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Colors.white;

  static const Color error = Color(0xFFDC3545); // Vermelho para erros
}
