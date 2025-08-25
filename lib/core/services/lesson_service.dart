import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';
import '../models/question_model.dart';

class LessonService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This method now fetches all documents from my 'lessons' collection in Firestore.
  Future<List<Lesson>> getLessons() async {
    try {
      final snapshot = await _db.collection('lessons').get();
      // I'm mapping the Firestore documents to my Lesson model.
      return snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList();
    } catch (e) {
      print(e.toString());
      return []; // Return an empty list on error.
    }
  }

  // This method now fetches all documents from my 'questions' collection in Firestore.
  Future<List<Question>> getQuestions() async {
    try {
      final snapshot = await _db.collection('questions').get();
      return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
