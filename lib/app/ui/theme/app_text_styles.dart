import 'package:flutter/material.dart';
import 'package:social_network/app/ui/theme/app_colors.dart';

// Classe para gerenciar os estilos de texto, promovendo uma tipografia uniforme.
abstract class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: AppColors.textPrimary,
  );
}
