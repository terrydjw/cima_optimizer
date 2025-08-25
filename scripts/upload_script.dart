// scripts/upload_script.dart
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cima_optimizer/firebase_options.dart';

// This is a standalone script to upload our local JSON data to Firestore.
Future<void> main() async {
  // I need to initialize Firebase before I can use its services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  // --- Upload Lessons ---
  print('Uploading lessons...');
  final lessonsFile = File('assets/lessons.json');
  final lessonsContent = await lessonsFile.readAsString();
  final List<dynamic> lessonsData = json.decode(lessonsContent);

  for (var lessonData in lessonsData) {
    // I'm creating a document for each lesson in the 'lessons' collection.
    await firestore.collection('lessons').add(lessonData);
  }
  print('Lessons uploaded successfully!');

  // --- Upload Questions ---
  print('Uploading questions...');
  final questionsFile = File('assets/questions.json');
  final questionsContent = await questionsFile.readAsString();
  final List<dynamic> questionsData = json.decode(questionsContent);

  for (var questionData in questionsData) {
    // I'm creating a document for each question in the 'questions' collection.
    await firestore.collection('questions').add(questionData);
  }
  print('Questions uploaded successfully!');
  print('--- Data upload complete. ---');
}
