import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../practice/providers/quiz_provider.dart';
import '../../shared/widgets/progress_card.dart';
import '../../core/models/lesson_model.dart';
import '../knowledge_hub/lesson_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final double syllabusCoverage = quizProvider.syllabusCoverage;
        final Lesson? recommendation = quizProvider.weakestTopic;
        final recentQuizzes = quizProvider.recentQuizzes;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              Text(
                'Syllabus Breakdown',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ProgressCard(
                title: 'Syllabus Area A: Ethics',
                value: quizProvider.getPerformanceForArea('A'),
                metricLabel:
                    '${(quizProvider.getPerformanceForArea('A') * 100).toStringAsFixed(0)}%',
                color: Colors.red.shade400,
              ),
              ProgressCard(
                title: 'Syllabus Area B: Governance',
                value: quizProvider.getPerformanceForArea('B'),
                metricLabel:
                    '${(quizProvider.getPerformanceForArea('B') * 100).toStringAsFixed(0)}%',
                color: Colors.blue.shade400,
              ),
              ProgressCard(
                title: 'Syllabus Area C: Law',
                value: quizProvider.getPerformanceForArea('C'),
                metricLabel:
                    '${(quizProvider.getPerformanceForArea('C') * 100).toStringAsFixed(0)}%',
                color: Colors.orange.shade400,
              ),
              const SizedBox(height: 24),

              Text(
                'Next Up: Your Recommendation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: recommendation == null
                    ? Card(
                        key: const ValueKey('no_recommendation'),
                        child: const ListTile(
                          leading: Icon(Icons.play_circle_outline),
                          title: Text(
                            'Complete a quiz to get a recommendation!',
                          ),
                        ),
                      )
                    : Card(
                        key: ValueKey('recommendation_${recommendation.id}'),
                        child: ListTile(
                          leading: const Icon(Icons.lightbulb_outline),
                          title: Text('Review: ${recommendation.title}'),
                          subtitle: const Text('This is your weakest area.'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LessonDetailScreen(lesson: recommendation),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (recentQuizzes.isEmpty)
                const Card(
                  child: ListTile(title: Text('No recent activity yet.')),
                )
              else
                ...recentQuizzes.map(
                  (result) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(result.topic),
                      subtitle: Text(
                        '${result.score}/${result.totalQuestions} correct',
                      ),
                      trailing: Text(
                        '${(result.score / result.totalQuestions * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
