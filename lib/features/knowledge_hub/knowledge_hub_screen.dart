import 'package:cima_optimizer/features/modules/models/module_details.dart';
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../practice/providers/quiz_provider.dart';
import '../../shared/widgets/syllabus_area_card.dart';
import 'lesson_list_screen.dart';

class KnowledgeHubScreen extends StatelessWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We get the selected module ID from the ModuleProvider.
    final moduleId = context.watch<ModuleProvider>().selectedModuleId?.trim();

    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no module is selected for any reason, show a message.
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
                'Choose an area to learn',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // We now use ListView.builder to dynamically create the cards.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: syllabusAreas.length,
                itemBuilder: (context, index) {
                  final area = syllabusAreas[index];
                  return SyllabusAreaCard(
                    title: area.title,
                    subtitle: area.subtitle,
                    icon: area.icon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // We pass the area ID (e.g., 'A', 'B') to the next screen.
                          builder: (context) => LessonListScreen(area: area.id),
                        ),
                      );
                    },
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
