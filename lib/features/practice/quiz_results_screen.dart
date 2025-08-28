import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_shell/main_screen.dart';
import './providers/quiz_provider.dart';

class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: ${quizProvider.sessionScore}/${quizProvider.totalQuestions}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // This robust navigation method prevents the black screen issue.
                Navigator.of(context)
                    .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(key: mainScreenKey),
                      ),
                      (Route<dynamic> route) => false,
                    )
                    .then((_) => mainScreenKey.currentState?.changeTab(0));
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
