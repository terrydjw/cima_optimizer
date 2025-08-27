import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:cima_optimizer/features/modules/screens/module_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/services/auth_service.dart';
import '../../practice/providers/quiz_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final quizProvider = context.watch<QuizProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final moduleProvider = context.read<ModuleProvider>();
    final user = authService.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile & Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(user?.email ?? 'Not logged in'),
              ),
            ),
            // This is the new card for changing the module.
            Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Change Module'),
                subtitle: Text(
                  'Currently studying: ${moduleProvider.selectedModuleId ?? ''}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Reset the providers to their initial state.
                  quizProvider.clearModuleData();
                  moduleProvider.clearModule();

                  // Navigate to the selection screen and remove all previous screens.
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const ModuleSelectionScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Lifetime Stats for ${moduleProvider.selectedModuleId ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      title: const Text('Syllabus Coverage'),
                      trailing: Text(
                        '${(quizProvider.syllabusCoverage * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.bar_chart_outlined,
                        color: Colors.blue,
                      ),
                      title: const Text('Total Questions Answered'),
                      trailing: Text(
                        quizProvider.totalAnsweredQuestions.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () => authService.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
