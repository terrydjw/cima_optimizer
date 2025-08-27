import 'package:cima_optimizer/core/services/ai_tutor_service.dart';
import 'package:cima_optimizer/core/theme/app_theme.dart';
import 'package:cima_optimizer/core/theme/theme_provider.dart';
import 'package:cima_optimizer/features/app_shell/main_screen.dart';
import 'package:cima_optimizer/features/auth/providers/auth_provider.dart';
import 'package:cima_optimizer/features/auth/screens/auth_wrapper.dart';
import 'package:cima_optimizer/features/auth/services/auth_service.dart';
// Add the import for our new provider.
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:cima_optimizer/features/practice/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // Add the new ModuleProvider to the list.
        ChangeNotifierProvider<ModuleProvider>(create: (_) => ModuleProvider()),

        Provider<AuthService>(create: (_) => AuthService()),
        // I am adding the AITutorService here so it can be used by other providers.
        Provider<AITutorService>(create: (_) => AITutorService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        // The QuizProvider now correctly receives the services it depends on.
        ChangeNotifierProvider<QuizProvider>(
          create: (context) => QuizProvider(
            context.read<AuthService>(),
            context.read<AITutorService>(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: const CimaOptimizerApp(),
    ),
  );
}

class CimaOptimizerApp extends StatelessWidget {
  const CimaOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CIMA Optimizer',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
