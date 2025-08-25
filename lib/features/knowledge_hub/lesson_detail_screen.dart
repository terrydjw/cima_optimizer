import 'package:flutter/material.dart';
import '../../core/models/lesson_model.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content section
            Text(
              lesson.content,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24.0),

            // Key points section
            Text('Key Points', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            ...lesson.keyPoints.map(
              (point) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(point),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
