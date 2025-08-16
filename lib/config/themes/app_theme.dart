import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teriak/config/themes/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        
        onPrimary: AppColors.onPrimaryLight,
        primaryContainer: AppColors.primaryVariantLight,
        onPrimaryContainer: AppColors.onPrimaryLight,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.onSecondaryLight,
        secondaryContainer: AppColors.secondaryVariantLight,
        onSecondaryContainer: AppColors.onSecondaryLight,
        tertiary: AppColors.secondaryLight,
        onTertiary: AppColors.onSecondaryLight,
        tertiaryContainer: AppColors.secondaryVariantLight,
        onTertiaryContainer: AppColors.onSecondaryLight,
        error: AppColors.errorLight,
        onError: AppColors.onErrorLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.dividerLight,
        shadow: AppColors.shadowLight,
        scrim: AppColors.shadowLight,
        inverseSurface: AppColors.surfaceDark,
        onInverseSurface: AppColors.onSurfaceDark,
        inversePrimary: AppColors.primaryDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.dividerLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 1.0,
        shadowColor: AppColors.shadowLight,
        titleTextStyle:
            _localizedFont(20, FontWeight.w600, AppColors.textPrimaryLight),
        toolbarTextStyle:
            _localizedFont(16, FontWeight.w500, AppColors.textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 2.0,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondaryLight,
        elevation: 8.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            _localizedFont(12, FontWeight.w500, AppColors.primaryLight),
        unselectedLabelStyle:
            _localizedFont(12, FontWeight.w400, AppColors.textSecondaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.onPrimaryLight,
          backgroundColor: AppColors.primaryLight,
          elevation: 2.0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle:
              _localizedFont(14, FontWeight.w500, AppColors.onPrimaryLight),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.primaryLight, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle:
              _localizedFont(14, FontWeight.w500, AppColors.primaryLight),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle:
              _localizedFont(14, FontWeight.w500, AppColors.primaryLight),
        ),
      ),
      textTheme: _buildTextTheme(context, isLight: true),

      // Input decoration optimized for healthcare forms
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surfaceLight,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppColors.primaryLight, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 2.0),
        ),
        labelStyle: _localizedFont(
            16, FontWeight.w400, AppColors.textSecondaryLight,
            letterSpacing: 0.5),
        hintStyle: _localizedFont(
            16, FontWeight.w400, AppColors.textDisabledLight,
            letterSpacing: 0.5),
        errorStyle: _localizedFont(12, FontWeight.w400, AppColors.errorLight,
            letterSpacing: 0.5),
      ),
      // Switch theme for settings and toggles
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.textDisabledLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight.withValues(alpha: 0.3);
          }
          return AppColors.borderLight;
        }),
      ),

      // Checkbox theme for form selections
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimaryLight),
        side: const BorderSide(color: AppColors.borderLight, width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),

      // Radio theme for single selections
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.borderLight;
        }),
      ),

      // Progress indicators for loading states
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),

      // Slider theme for value adjustments
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryLight,
        thumbColor: AppColors.primaryLight,
        overlayColor: AppColors.primaryLight.withValues(alpha: 0.2),
        inactiveTrackColor: AppColors.borderLight,
        trackHeight: 4.0,
      ),
      // Tab bar theme for navigation
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryLight,
        unselectedLabelColor: AppColors.textSecondaryLight,
        indicatorColor: AppColors.primaryLight,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: _localizedFont(14, FontWeight.w600, AppColors.primaryLight),
        unselectedLabelStyle:
            _localizedFont(14, FontWeight.w400, AppColors.textSecondaryLight),
      ),

      // Tooltip theme for helpful information
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimaryLight.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: _localizedFont(
          12,
          FontWeight.w400,
          AppColors.surfaceLight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // SnackBar theme for notifications
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: _localizedFont(
          14,
          FontWeight.w400,
          AppColors.surfaceLight,
        ),
        actionTextColor: AppColors.secondaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
      ),

      // Bottom sheet theme for contextual actions
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
      ),

      // Dialog theme for important latoactions
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.dialogLight,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: _localizedFont(
          20,
          FontWeight.w600,
          AppColors.textPrimaryLight,
        ),
        contentTextStyle: _localizedFont(
          16,
          FontWeight.w400,
          AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        primaryContainer: AppColors.primaryVariantDark,
        onPrimaryContainer: AppColors.onPrimaryDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        secondaryContainer: AppColors.secondaryVariantDark,
        onSecondaryContainer: AppColors.onSecondaryDark,
        tertiary: AppColors.secondaryDark,
        onTertiary: AppColors.onSecondaryDark,
        tertiaryContainer: AppColors.secondaryVariantDark,
        onTertiaryContainer: AppColors.onSecondaryDark,
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.dividerDark,
        shadow: AppColors.shadowDark,
        scrim: AppColors.shadowDark,
        inverseSurface: AppColors.surfaceLight,
        onInverseSurface: AppColors.onSurfaceLight,
        inversePrimary: AppColors.primaryLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.dividerDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 1.0,
        shadowColor: AppColors.shadowDark,
        titleTextStyle:
            _localizedFont(20, FontWeight.w600, AppColors.textPrimaryDark),
        toolbarTextStyle:
            _localizedFont(16, FontWeight.w500, AppColors.textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 2.0,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textSecondaryDark,
        elevation: 8.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            _localizedFont(12, FontWeight.w500, AppColors.primaryDark),
        unselectedLabelStyle:
            _localizedFont(12, FontWeight.w400, AppColors.textSecondaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.onPrimaryDark,
          backgroundColor: AppColors.primaryDark,
          elevation: 2.0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle:
              _localizedFont(14, FontWeight.w500, AppColors.onPrimaryDark),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.primaryDark, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: _localizedFont(14, FontWeight.w500, AppColors.primaryDark),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: _localizedFont(14, FontWeight.w500, AppColors.primaryDark),
        ),
      ),
      textTheme: _buildTextTheme(context, isLight: false),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surfaceDark,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppColors.primaryDark, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 2.0),
        ),
        labelStyle: _localizedFont(
          16,
          FontWeight.w400,
          AppColors.textSecondaryDark,
        ),
        hintStyle: _localizedFont(
          16,
          FontWeight.w400,
          AppColors.textDisabledDark,
        ),
        errorStyle: _localizedFont(
          12,
          FontWeight.w400,
          AppColors.errorDark,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return AppColors.textDisabledDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark.withValues(alpha: 0.3);
          }
          return AppColors.borderDark;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimaryDark),
        side: const BorderSide(color: AppColors.borderDark, width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return AppColors.borderDark;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        linearTrackColor: AppColors.borderDark,
        circularTrackColor: AppColors.borderDark,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryDark,
        thumbColor: AppColors.primaryDark,
        overlayColor: AppColors.primaryDark.withValues(alpha: 0.2),
        inactiveTrackColor: AppColors.borderDark,
        trackHeight: 4.0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryDark,
        unselectedLabelColor: AppColors.textSecondaryDark,
        indicatorColor: AppColors.primaryDark,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: _localizedFont(14, FontWeight.w600, AppColors.primaryDark),
        unselectedLabelStyle:
            _localizedFont(14, FontWeight.w400, AppColors.textSecondaryDark),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimaryDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: _localizedFont(
          12,
          FontWeight.w400,
          AppColors.backgroundDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryDark,
        contentTextStyle: _localizedFont(
          14,
          FontWeight.w400,
          AppColors.backgroundDark,
        ),
        actionTextColor: AppColors.secondaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.dialogDark,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: _localizedFont(
          20,
          FontWeight.w600,
          AppColors.textPrimaryDark,
        ),
        contentTextStyle: _localizedFont(
          16,
          FontWeight.w400,
          AppColors.textPrimaryDark,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(BuildContext context,
      {required bool isLight}) {
    final Color textPrimary =
        isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
    final Color textSecondary =
        isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;
    // final Color textDisabled =
    //     isLight ? AppColors.textDisabledLight : AppColors.textDisabledDark;

    return TextTheme(
      displayLarge: _localizedFont(57, FontWeight.w400, textPrimary,
          letterSpacing: -0.25),
      displayMedium: _localizedFont(45, FontWeight.w400, textPrimary),
      displaySmall: _localizedFont(36, FontWeight.w400, textPrimary),
      headlineLarge: _localizedFont(32, FontWeight.w600, textPrimary),
      headlineMedium: _localizedFont(28, FontWeight.w600, textPrimary),
      headlineSmall: _localizedFont(24, FontWeight.w600, textPrimary),
      titleLarge: _localizedFont(22, FontWeight.w500, textPrimary),
      titleMedium:
          _localizedFont(16, FontWeight.w500, textPrimary, letterSpacing: 0.15),
      titleSmall:
          _localizedFont(14, FontWeight.w500, textPrimary, letterSpacing: 0.1),
      bodyLarge:
          _localizedFont(16, FontWeight.w400, textPrimary, letterSpacing: 0.5),
      bodyMedium:
          _localizedFont(14, FontWeight.w400, textPrimary, letterSpacing: 0.25),
      bodySmall: _localizedFont(12, FontWeight.w400, textSecondary,
          letterSpacing: 0.4),
      labelLarge:
          _localizedFont(14, FontWeight.w500, textPrimary, letterSpacing: 0.1),
      labelMedium:
          _localizedFont(12, FontWeight.w500, textPrimary, letterSpacing: 0.5),
      labelSmall:
          _localizedFont(11, FontWeight.w500, textPrimary, letterSpacing: 0.5),
    );
  }

  static TextStyle _localizedFont(
    double size,
    FontWeight weight,
    Color color, {
    double? letterSpacing,
  }) {
    final isArabic = Get.locale?.languageCode == 'ar';

    return isArabic
        ? GoogleFonts.tajawal(
            fontSize: size,
            fontWeight: weight,
            color: color,
            letterSpacing: letterSpacing,
          )
        : GoogleFonts.lato(
            fontSize: size,
            fontWeight: weight,
            color: color,
            letterSpacing: letterSpacing,
          );
  }
}
