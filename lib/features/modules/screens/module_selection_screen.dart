import 'package:cima_optimizer/core/services/lesson_service.dart';
import 'package:cima_optimizer/features/app_shell/main_screen.dart';
import 'package:cima_optimizer/features/modules/providers/module_provider.dart';
import 'package:cima_optimizer/features/practice/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  // We use a Future to hold the result of our service call.
  late final Future<List<Map<String, dynamic>>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the modules when the screen is first built.
    _modulesFuture = LessonService().getAvailableModules();
  }

  // This method will be called when a user selects a module.
  void _selectModule(String moduleId) {
    // We use listen: false because we are in a method, not the build method.
    final moduleProvider = context.read<ModuleProvider>();
    final quizProvider = context.read<QuizProvider>();

    // 1. Set the selected module in the ModuleProvider.
    moduleProvider.selectModule(moduleId);

    // 2. Trigger the data loading in the QuizProvider.
    quizProvider.loadDataForModule(moduleId);

    // 3. Navigate to the main app screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(key: mainScreenKey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Module'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _modulesFuture,
        builder: (context, snapshot) {
          // Show a loading spinner while fetching data.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show an error message if something went wrong.
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If there's no data, show a message.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No modules found.'));
          }

          final modules = snapshot.data!;

          // Once data is loaded, display it in a list.
          return ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              final moduleId = module['id'];
              final moduleTitle = module['title'] ?? 'Unnamed Module';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(moduleTitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _selectModule(moduleId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
