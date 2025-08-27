import 'package:flutter/material.dart';

class NotepadDialog extends StatelessWidget {
  const NotepadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scratchpad'),
      content: const SizedBox(
        width: 300,
        height: 200,
        child: TextField(
          maxLines: null, // Allows for multiline input
          expands: true, // Expands to fill the available space
          decoration: InputDecoration(
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
