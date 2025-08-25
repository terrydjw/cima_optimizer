import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/services/auth_service.dart';
import '../../practice/providers/quiz_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final quizProvider = Provider.of<QuizProvider>(context);
    // I'm getting my themeProvider to control the dark mode switch.
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            // I'm adding my new Dark Mode toggle here.
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
              'Lifetime Stats',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
