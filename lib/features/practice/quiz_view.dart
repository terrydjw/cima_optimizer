import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/calculator_dialog.dart';
import '../../shared/widgets/notepad_dialog.dart';
import './providers/quiz_provider.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuestion = quizProvider.currentQuestion;
    final syllabusArea = currentQuestion.id.substring(0, 1);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'notepad_button',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NotepadDialog(),
              );
            },
            tooltip: 'Scratchpad',
            child: const Icon(Icons.edit_note),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'calculator_button',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CalculatorDialog(),
              );
            },
            tooltip: 'Calculator',
            child: const Icon(Icons.calculate),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 8),
            Text(
              'Syllabus Area $syllabusArea',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
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
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: quizProvider.answerChecked
                  ? Card(
                      color: Theme.of(
                        context,
                      ).cardTheme.color?.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (quizProvider.isExplanationLoading)
                              const Center(child: CircularProgressIndicator()),

                            if (quizProvider.explanationText != null)
                              Text(quizProvider.explanationText!),

                            if (!quizProvider.isExplanationLoading &&
                                quizProvider.explanationText == null)
                              TextButton.icon(
                                icon: const Icon(Icons.lightbulb_outline),
                                label: const Text('Explain this to me'),
                                onPressed: () => quizProvider.getExplanation(),
                              ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
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
          ],
        ),
      ),
    );
  }
}
