import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/practice/providers/quiz_provider.dart';

class NotepadDialog extends StatefulWidget {
  const NotepadDialog({super.key});

  @override
  State<NotepadDialog> createState() => _NotepadDialogState();
}

class _NotepadDialogState extends State<NotepadDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final quizProvider = context.read<QuizProvider>();
    // Initialize the controller with the text from the provider.
    _controller = TextEditingController(text: quizProvider.notepadText);

    // Add a listener to save the text back to the provider on every change.
    _controller.addListener(() {
      quizProvider.updateNotepadText(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scratchpad'),
      content: SizedBox(
        width: 300,
        height: 200,
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            hintText: 'Your notes...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
