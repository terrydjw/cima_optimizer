import 'package:cima_optimizer/features/modules/screens/module_selection_screen.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../../app_shell/main_screen.dart';
import 'auth_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          // If the user is logged in, show the ModuleSelectionScreen.
          // Otherwise, show the AuthScreen.
          return user == null
              ? const AuthScreen()
              // This is the only line that changes.
              : const ModuleSelectionScreen();
        }
        // While waiting for the auth state, show a loading spinner.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
