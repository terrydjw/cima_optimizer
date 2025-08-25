import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../practice/providers/quiz_provider.dart';
import '../../shared/widgets/syllabus_area_card.dart';
import 'lesson_list_screen.dart';

class KnowledgeHubScreen extends StatelessWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose an area to learn',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SyllabusAreaCard(
                title: 'Syllabus Area A',
                subtitle: 'Business Ethics & Ethical Conflict',
                icon: Icons.shield_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LessonListScreen(area: 'A'),
                    ),
                  );
                },
              ),
              SyllabusAreaCard(
                title: 'Syllabus Area B',
                subtitle: 'Corporate Governance & Controls',
                icon: Icons.account_balance_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LessonListScreen(area: 'B'),
                    ),
                  );
                },
              ),
              SyllabusAreaCard(
                title: 'Syllabus Area C',
                subtitle: 'Business & Employment Law',
                icon: Icons.gavel_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LessonListScreen(area: 'C'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
