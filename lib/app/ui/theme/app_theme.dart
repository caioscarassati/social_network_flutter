import 'package:flutter/material.dart';
import 'package:social_network/app/ui/theme/app_colors.dart';
import 'package:social_network/app/ui/theme/app_text_styles.dart';

// ThemeData centralizado para garantir uma UI consistente em todo o aplicativo.
final ThemeData appThemeData = ThemeData(
  // Cores principais
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    error: AppColors.error,
  ),

  // Tema do AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headline.copyWith(color: AppColors.textLight),
    iconTheme: const IconThemeData(color: AppColors.textLight),
  ),

  // Tema dos botões elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
      textStyle: AppTextStyles.button,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),

  // Tema dos campos de texto
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    labelStyle: AppTextStyles.inputLabel,
    prefixIconColor: AppColors.primary,
  ),

  // Tema do Card
  cardTheme: CardThemeData(
    elevation: 4.0,
    color: AppColors.card,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),

  // Estilos de texto padrão
  textTheme: const TextTheme(
    headlineSmall: AppTextStyles.headline,
    bodyLarge: AppTextStyles.bodyText,
    labelLarge: AppTextStyles.button,
  ),

  // Tema do CircularProgressIndicator
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
  ),
);
