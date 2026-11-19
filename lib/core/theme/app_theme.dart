import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'typography.dart';

/// Complete Material 3 Theme definitions for Light and Dark modes.
abstract class AppTheme {
  /// Light Theme Definition
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.householdScope,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.householdScopeContainer,
      onSecondaryContainer: AppColors.householdScope,
      tertiary: AppColors.personalScope,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.personalScopeContainer,
      onTertiaryContainer: AppColors.personalScope,
      error: AppColors.expense,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.lightBackground,
      surfaceContainer: AppColors.lightSurfaceSubtle,
      surfaceContainerHigh: Color(0xFFE8EEF5),
      outline: AppColors.lightBorder,
      outlineVariant: Color(0xFFCBD5E1),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textTheme(AppColors.lightTextPrimary),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLarge,
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        color: AppColors.lightSurface,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        height: AppDimensions.bottomNavHeight,
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primaryContainerLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryDark, size: 24);
          }
          return const IconThemeData(
            color: AppColors.lightTextSecondary,
            size: 24,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          side: const BorderSide(color: AppColors.lightBorder),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        hintStyle: const TextStyle(
          color: AppColors.lightTextMuted,
          fontSize: 14,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark Theme Definition
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF4CAF50),
      onPrimary: Colors.black,
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: Color(0xFFC8E6C9),
      secondary: Color(0xFF26A69A),
      onSecondary: Colors.black,
      secondaryContainer: Color(0xFF004D40),
      onSecondaryContainer: Color(0xFFB2DFDB),
      tertiary: Color(0xFF7986CB),
      onTertiary: Colors.black,
      tertiaryContainer: Color(0xFF1A237E),
      onTertiaryContainer: Color(0xFFC5CAE9),
      error: Color(0xFFEF5350),
      onError: Colors.black,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerLowest: Color(0xFF0B111E),
      surfaceContainerLow: AppColors.darkBackground,
      surfaceContainer: AppColors.darkSurfaceSubtle,
      surfaceContainerHigh: Color(0xFF2E3E55),
      outline: AppColors.darkBorder,
      outlineVariant: Color(0xFF475569),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textTheme(AppColors.darkTextPrimary),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLarge,
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        color: AppColors.darkSurface,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        height: AppDimensions.bottomNavHeight,
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryContainerDark,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF81C784),
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF81C784), size: 24);
          }
          return const IconThemeData(
            color: AppColors.darkTextSecondary,
            size: 24,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.black,
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.black,
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF81C784),
          minimumSize: const Size(64, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          side: const BorderSide(color: AppColors.darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: Color(0xFF81C784), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: Color(0xFFEF5350)),
        ),
        hintStyle: const TextStyle(
          color: AppColors.darkTextMuted,
          fontSize: 14,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
