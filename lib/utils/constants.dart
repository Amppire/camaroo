import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Camaroo';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Camera Application';

  // Camera Settings Defaults
  static const double defaultShutterSpeed = 1 / 125;
  static const double defaultExposureTime = 1 / 125;
  static const double defaultISO = 100;
  static const double defaultFocalLength = 24;
  static const double defaultWhiteBalance = 5500;

  // Camera Settings Ranges
  static const double minShutterSpeed = 1 / 8000;
  static const double maxShutterSpeed = 1 / 30;
  static const double minISO = 100;
  static const double maxISO = 3200;
  static const double minFocalLength = 10;
  static const double maxFocalLength = 200;
  static const double minWhiteBalance = 2000;
  static const double maxWhiteBalance = 10000;

  // UI Constants
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double compactPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Grid
  static const int photoGridCrossAxisCount = 3;
  static const double photoGridSpacing = 4.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // File Settings
  static const int jpegQuality = 95;
  static const String photoPrefix = 'IMG';
  static const String editedPhotoPrefix = 'EDIT';
  static const String photoExtension = 'jpg';

  // Database
  static const String databaseName = 'camaroo.db';
  static const int databaseVersion = 1;

  // Storage Keys
  static const String settingsKey = 'camera_settings';
  static const String favoritesKey = 'favorites';
  static const String albumsKey = 'albums';
}

/// Application colors
class AppColors {
  // Primary colors
  static const Color primary = Colors.blue;
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFF03A9F4);

  // Background colors
  static const Color background = Colors.black;
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textDisabled = Color(0xFF666666);

  // UI Element colors
  static const Color border = Color(0xFF333333);
  static const Color divider = Color(0xFF2A2A2A);
  static const Color overlay = Color(0x80000000);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}

/// Application text styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
