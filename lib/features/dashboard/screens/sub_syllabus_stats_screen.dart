import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../practice/providers/quiz_provider.dart';
import '../../knowledge_hub/lesson_detail_screen.dart';

class SubSyllabusStatsScreen extends StatelessWidget {
  final String areaId;
  final String areaTitle;

  const SubSyllabusStatsScreen({
    super.key,
    required this.areaId,
    required this.areaTitle,
  });

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    // Get the performance map for all sub-topics
    final performanceData = quizProvider.subTopicPerformance;
    // Get all lessons to find the titles for our sub-topics
    final allLessons = quizProvider.lessons;

    // Filter the keys to get only the sub-topics for the selected area (e.g., 'A1', 'A2' for 'A')
    final subAreaKeys = performanceData.keys
        .where((key) => key.startsWith(areaId))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(areaTitle)),
      body: subAreaKeys.isEmpty
          ? const Center(
              child: Text(
                'No data available yet. Complete a few questions in this area to see your stats.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: subAreaKeys.length,
              itemBuilder: (context, index) {
                final subAreaKey = subAreaKeys[index];
                final performance = performanceData[subAreaKey] ?? 0.0;

                // Find the corresponding lesson to get the title
                final lesson = allLessons.firstWhere(
                  (l) => l.id == subAreaKey,
                  // Provide a fallback lesson if not found
                  orElse: () => allLessons.first,
                );

                return Card(
                  child: ListTile(
                    title: Text('${lesson.id}: ${lesson.title}'),
                    subtitle: LinearProgressIndicator(
                      value: performance,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        performance < 0.5
                            ? Colors.red.shade400
                            : Colors.green.shade400,
                      ),
                    ),
                    trailing: Text(
                      '${(performance * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LessonDetailScreen(lesson: lesson),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
