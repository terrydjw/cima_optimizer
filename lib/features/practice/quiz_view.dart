import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/ai_tutor_service.dart';
import './providers/quiz_provider.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  void _showExplanation(
    BuildContext context,
    String question,
    String correctAnswer,
    List<String> allOptions,
  ) async {
    final tutorService = AITutorService();

    // I'll show a loading dialog while the AI is thinking.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final explanation = await tutorService.getExplanation(
      question: question,
      correctAnswer: correctAnswer,
      allOptions: allOptions,
    );

    // I need to close the loading dialog.
    Navigator.of(context).pop();

    // I'll show the explanation in a bottom sheet.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Tutor Explanation',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(explanation ?? 'No explanation available.'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuestion = quizProvider.currentQuestion;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.totalQuestions}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => quizProvider.cancelQuiz(),
                tooltip: 'End Quiz',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentQuestion.questionText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...List.generate(currentQuestion.options.length, (index) {
            final isCorrect = index == currentQuestion.correctAnswerIndex;
            final isSelected = index == quizProvider.selectedAnswerIndex;
            Color? tileColor;

            if (quizProvider.answerChecked) {
              if (isCorrect) {
                tileColor = Colors.green.shade100;
              } else if (isSelected) {
                tileColor = Colors.red.shade100;
              }
            }

            return Card(
              color: tileColor,
              child: ListTile(
                title: Text(currentQuestion.options[index]),
                onTap: () => quizProvider.selectAnswer(index),
                selected: isSelected,
              ),
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: quizProvider.selectedAnswerIndex == null
                ? null
                : (quizProvider.answerChecked
                      ? () => quizProvider.nextQuestion(context)
                      : quizProvider.checkAnswer),
            child: Text(
              quizProvider.answerChecked ? 'Next Question' : 'Check Answer',
            ),
          ),
          // I'm adding my new "Explain" button here.
          // It only appears after the user has checked their answer.
          if (quizProvider.answerChecked)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Explain this to me'),
                onPressed: () {
                  final correctAnswerText = currentQuestion
                      .options[currentQuestion.correctAnswerIndex];
                  _showExplanation(
                    context,
                    currentQuestion.questionText,
                    correctAnswerText,
                    currentQuestion.options,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
