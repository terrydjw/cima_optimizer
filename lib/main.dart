import 'package:cima_optimizer/core/theme/app_theme.dart';
import 'package:cima_optimizer/core/theme/theme_provider.dart';
import 'package:cima_optimizer/features/app_shell/main_screen.dart';
import 'package:cima_optimizer/features/auth/providers/auth_provider.dart';
import 'package:cima_optimizer/features/auth/screens/auth_wrapper.dart';
import 'package:cima_optimizer/features/auth/services/auth_service.dart';
import 'package:cima_optimizer/features/practice/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env"); // I'm loading my environment variables.

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<QuizProvider>(create: (_) => QuizProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        // I'm adding my new ThemeProvider here.
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const CimaOptimizerApp(),
    ),
  );
}

class CimaOptimizerApp extends StatelessWidget {
  const CimaOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // I'm wrapping my MaterialApp in a Consumer to listen for theme changes.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CIMA Optimizer',
          // I'm setting the theme, darkTheme, and themeMode properties.
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
