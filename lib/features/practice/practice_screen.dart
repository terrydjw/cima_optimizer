import 'package:cima_optimizer/features/modules/models/module_details.dart';
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/question_model.dart'; // Add this import to fix the error
import '../../shared/widgets/syllabus_area_card.dart';
import 'providers/quiz_provider.dart';
import 'quiz_options_screen.dart';
import 'quiz_view.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final moduleId = context.watch<ModuleProvider>().selectedModuleId;

    void navigateToOptions(
      String? area,
      String title, {
      List<Question>? questions,
    }) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizOptionsScreen(area: area, title: title, questions: questions),
        ),
      );
    }

    if (quizProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (quizProvider.status == QuizStatus.inProgress) {
      return const QuizView();
    }

    if (moduleId == null) {
      return const Center(child: Text('Please select a module first.'));
    }

    final syllabusAreas = getSyllabusAreasForModule(moduleId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose an area to practice',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          SyllabusAreaCard(
            title: 'Practice Weak Areas',
            subtitle: 'Focus on questions you haven\'t mastered yet',
            icon: Icons.psychology_alt_outlined,
            onTap: () {
              final weakQuestions = quizProvider.weakQuestions;
              if (weakQuestions.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Congratulations! You have mastered all questions in this module.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                navigateToOptions(
                  null,
                  'Practice Weak Areas',
                  questions: weakQuestions,
                );
              }
            },
          ),

          SyllabusAreaCard(
            title: 'Full Syllabus',
            subtitle: 'Questions from all areas',
            icon: Icons.all_inclusive,
            onTap: () => navigateToOptions(null, 'Full Syllabus'),
          ),

          ...syllabusAreas.map((area) {
            return SyllabusAreaCard(
              title: area.title,
              subtitle: area.subtitle,
              icon: area.icon,
              onTap: () => navigateToOptions(area.id, area.title),
            );
          }),
        ],
      ),
    );
  }
}
