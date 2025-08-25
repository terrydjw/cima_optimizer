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
    void _navigateToOptions(String? area, String title) {
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
                title: 'Full Syllabus',
                subtitle: 'Questions from all areas',
                icon: Icons.all_inclusive,
                onTap: () => _navigateToOptions(null, 'Full Syllabus'),
              ),
              SyllabusAreaCard(
                title: 'Syllabus Area A',
                subtitle: 'Business Ethics & Ethical Conflict',
                icon: Icons.shield_outlined,
                onTap: () => _navigateToOptions('A', 'Syllabus Area A'),
              ),
              SyllabusAreaCard(
                title: 'Syllabus Area B',
                subtitle: 'Corporate Governance & Controls',
                icon: Icons.account_balance_outlined,
                onTap: () => _navigateToOptions('B', 'Syllabus Area B'),
              ),
              SyllabusAreaCard(
                title: 'Syllabus Area C',
                subtitle: 'Business & Employment Law',
                icon: Icons.gavel_outlined,
                onTap: () => _navigateToOptions('C', 'Syllabus Area C'),
              ),
            ],
          ),
        );
      },
    );
  }
}
