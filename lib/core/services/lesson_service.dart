import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';
import '../models/question_model.dart';

class LessonService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This new method fetches the documents from the top-level 'modules' collection.
  Future<List<Map<String, dynamic>>> getAvailableModules() async {
    try {
      final snapshot = await _db.collection('modules').get();
      // We return a list of maps, which can contain module ID, title, etc.
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // This method now requires a moduleId to fetch from the correct sub-collection.
  Future<List<Lesson>> getLessons({required String moduleId}) async {
    try {
      // The path now points to the sub-collection within a specific module.
      final snapshot = await _db
          .collection('modules')
          .doc(moduleId)
          .collection('lessons')
          .get();
      return snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList();
    } catch (e) {
      print(e.toString());
      return []; // Return an empty list on error.
    }
  }

  // This method also now requires a moduleId.
  Future<List<Question>> getQuestions({required String moduleId}) async {
    try {
      // The path is updated here as well.
      final snapshot = await _db
          .collection('modules')
          .doc(moduleId)
          .collection('questions')
          .get();
      return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
