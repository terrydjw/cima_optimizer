import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import '../../core/models/question_model.dart';
import 'package:flutter/services.dart';

class QuizOptionsScreen extends StatefulWidget {
  final String? area;
  final String title;

  const QuizOptionsScreen({super.key, this.area, required this.title});

  @override
  State<QuizOptionsScreen> createState() => _QuizOptionsScreenState();
}

class _QuizOptionsScreenState extends State<QuizOptionsScreen> {
  final TextEditingController _questionCountController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _questionCountController.dispose();
    super.dispose();
  }

  void _startQuiz(BuildContext context, int count) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final availableQuestions = quizProvider.getQuestionsForArea(widget.area);

    // I'm validating one last time before starting.
    if (count > 0 && count <= availableQuestions.length) {
      final selectedQuestions = (availableQuestions..shuffle())
          .take(count)
          .toList();
      quizProvider.startQuiz(selectedQuestions, widget.title);
      // I'm popping the options screen off the navigation stack.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final availableQuestions = quizProvider.getQuestionsForArea(widget.area);

    final List<int> questionCounts = [5, 10, 20];
    if (availableQuestions.length > 20 &&
        !questionCounts.contains(availableQuestions.length)) {
      questionCounts.add(availableQuestions.length);
    } else if (!questionCounts.contains(availableQuestions.length)) {
      questionCounts.add(availableQuestions.length);
    }
    questionCounts.removeWhere((count) => count > availableQuestions.length);
    questionCounts.sort();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select number of questions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              // I'm creating a grid for my preset options.
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: questionCounts.length,
                itemBuilder: (context, index) {
                  final count = questionCounts[index];
                  return ElevatedButton(
                    onPressed: () => _startQuiz(context, count),
                    child: Text(
                      count == availableQuestions.length ? 'All' : '$count',
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              Text(
                'Or enter manually',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _questionCountController,
                decoration: InputDecoration(
                  labelText:
                      'Enter a number (max ${availableQuestions.length})',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Invalid number';
                  }
                  if (number <= 0 || number > availableQuestions.length) {
                    return 'Must be between 1 and ${availableQuestions.length}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final count = int.parse(_questionCountController.text);
                      _startQuiz(context, count);
                    }
                  },
                  child: const Text('Start Manual Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
