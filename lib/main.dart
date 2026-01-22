import 'package:auctify/splashScreen.dart';
import 'package:auctify/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:auctify/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Auctify',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,

          /// LIGHT THEME
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.scaffoldBg,
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.textPrimary,
              iconTheme: IconThemeData(color: AppColors.textPrimary),
            ),
            elevatedButtonTheme: _elevatedButtonTheme(),
            cardTheme: CardThemeData(
              color: AppColors.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              ),
            ),
            inputDecorationTheme: _inputDecorationTheme(Colors.white),
            textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
                .apply(
                  bodyColor: AppColors.textPrimary,
                  displayColor: AppColors.textPrimary,
                ),
          ),

          /// DARK THEME
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkScaffoldBg,
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              brightness: Brightness.dark,
              surface: AppColors.darkCardBg,
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.darkTextPrimary,
              iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
            ),
            elevatedButtonTheme: _elevatedButtonTheme(),
            cardTheme: CardThemeData(
              color: AppColors.darkCardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              ),
            ),
            inputDecorationTheme: _inputDecorationTheme(AppColors.darkCardBg),
            textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
                .apply(
                  bodyColor: AppColors.darkTextPrimary,
                  displayColor: AppColors.darkTextPrimary,
                ),
          ),
          home: SplashScreen(),
          // initialRoute: AppRoutes.SplashScreen,
          // routes: AppRoutes.routes,
          // onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }

  ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme(Color fillColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.all(AppSizes.paddingMD),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        borderSide: BorderSide.none,
      ),
    );
  }
}
