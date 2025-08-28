import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../practice/providers/quiz_provider.dart';
import 'lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  final String area;
  const LessonListScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    // Use listen: true here or wrap in a Consumer to get lessons after they're loaded
    final quizProvider = Provider.of<QuizProvider>(context);
    final lessons = quizProvider.lessons
        .where((l) => l.syllabusArea == area)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Syllabus Area $area')),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Hero(
                tag: 'lesson_title_${lesson.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(lesson: lesson),
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
