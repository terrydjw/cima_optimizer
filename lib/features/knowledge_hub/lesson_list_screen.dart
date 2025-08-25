import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../practice/providers/quiz_provider.dart';
import 'lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  final String area;
  const LessonListScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
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
              // I'm wrapping my title in a Hero widget with a unique tag.
              title: Hero(
                tag: 'lesson_title_${lesson.id}',
                child: Material(
                  // This Material widget prevents text style clashes during the animation.
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
