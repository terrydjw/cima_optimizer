import 'package:cima_optimizer/features/modules/models/module_details.dart';
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/syllabus_area_card.dart';
import 'providers/quiz_provider.dart';
import 'quiz_options_screen.dart';
import 'quiz_view.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We get the selected module ID from the ModuleProvider.
    final moduleId = context.watch<ModuleProvider>().selectedModuleId?.trim();

    void navigateToOptions(String? area, String title) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizOptionsScreen(area: area, title: title),
        ),
      );
    }

    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (quizProvider.status == QuizStatus.inProgress) {
          return const QuizView();
        }

        // If no module is selected, show a message.
        if (moduleId == null) {
          return const Center(child: Text('Please select a module first.'));
        }

        // Get the dynamic list of syllabus areas for the current module.
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
              // This card for the full syllabus remains.
              SyllabusAreaCard(
                title: 'Full Syllabus',
                subtitle: 'Questions from all areas',
                icon: Icons.all_inclusive,
                onTap: () => navigateToOptions(null, 'Full Syllabus'),
              ),
              // I'm using the spread operator (...) to add our dynamic list of cards here.
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
      },
    );
  }
}
