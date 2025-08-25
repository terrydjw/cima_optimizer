import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// This is a temporary main function to run our upload logic.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  print('--- Starting Data Upload ---');

  // --- Upload Lessons ---
  print('Uploading lessons...');
  // This path needs to be updated if you run from a different context.
  // For simplicity, we assume the script is run from the project root.
  final lessonsFile = File('assets/lessons.json');
  final lessonsContent = await lessonsFile.readAsString();
  final List<dynamic> lessonsData = json.decode(lessonsContent);

  for (var lessonData in lessonsData) {
    await firestore.collection('lessons').add(lessonData);
  }
  print('Lessons uploaded successfully!');

  // --- Upload Questions ---
  print('Uploading questions...');
  final questionsFile = File('assets/questions.json');
  final questionsContent = await questionsFile.readAsString();
  final List<dynamic> questionsData = json.decode(questionsContent);

  for (var questionData in questionsData) {
    await firestore.collection('questions').add(questionData);
  }
  print('Questions uploaded successfully!');

  print('--- Data upload complete. ---');

  // Keep the app running for a moment to ensure the script completes.
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('Upload Complete!'))),
    ),
  );
}
