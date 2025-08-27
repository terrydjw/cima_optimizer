import 'package:cima_optimizer/features/dashboard/screens/sub_syllabus_stats_screen.dart';
import 'package:cima_optimizer/features/modules/models/module_details.dart';
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
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
    final moduleId = context.watch<ModuleProvider>().selectedModuleId;

    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (moduleId == null || quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final syllabusAreas = getSyllabusAreasForModule(moduleId);
        final recommendation = quizProvider.weakestTopic;
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

              // This is the updated, dynamic section
              ...syllabusAreas.asMap().entries.map((entry) {
                final idx = entry.key;
                final area = entry.value;

                final colors = [
                  Colors.red.shade400,
                  Colors.blue.shade400,
                  Colors.orange.shade400,
                  Colors.green.shade400,
                  Colors.purple.shade400,
                ];
                final color = colors[idx % colors.length];
                final performance = quizProvider.getPerformanceForArea(area.id);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubSyllabusStatsScreen(
                          areaId: area.id,
                          areaTitle: area.title,
                        ),
                      ),
                    );
                  },
                  child: ProgressCard(
                    title: area.title,
                    subtitle: area.subtitle,
                    value: performance,
                    metricLabel: '${(performance * 100).toStringAsFixed(0)}%',
                    color: color,
                  ),
                );
              }),

              const SizedBox(height: 24),

              // This is the restored Recommendation section
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

              // This is the restored Recent Activity section
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
