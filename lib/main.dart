import 'package:azkar_app/core/settings/app_settings.dart';
import 'package:azkar_app/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  runApp(const AzkarApp());
}

class AzkarApp extends StatelessWidget {
  const AzkarApp({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppSettings.instance,
        builder: (context, _) => AppSettingsScope(
          settings: AppSettings.instance,
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Azkar',
          themeMode: AppSettings.instance.themeMode,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          home: const HomeScreen(),
          ),
        ),
      );

  ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B5D4B), brightness: brightness,
      primary: isDark ? const Color(0xFF78C7AD) : const Color(0xFF0B5D4B),
      secondary: const Color(0xFFC49A3A),
      surface: isDark ? const Color(0xFF121B18) : const Color(0xFFFFFDF8),
    );
    return ThemeData(
      useMaterial3: true, colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF0D1412) : const Color(0xFFF7F8F5),
      appBarTheme: AppBarTheme(elevation: 0, scrolledUnderElevation: 0, backgroundColor: scheme.surface, foregroundColor: scheme.onSurface),
      cardTheme: CardThemeData(elevation: 0, color: scheme.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: scheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
    );
  }
}
