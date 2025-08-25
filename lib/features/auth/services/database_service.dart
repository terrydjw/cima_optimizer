import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserProgress({
    required String userId,
    required Set<String> answeredQuestionIds,
    required Map<String, int> topicAttempts,
    required Map<String, int> topicCorrectAnswers,
    required List<Map<String, dynamic>> recentQuizzes,
  }) async {
    try {
      final userDocRef = _db.collection('users').doc(userId);
      await userDocRef.set({
        'answeredQuestionIds': answeredQuestionIds.toList(),
        'topicAttempts': topicAttempts,
        'topicCorrectAnswers': topicCorrectAnswers,
        'recentQuizzes': recentQuizzes,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserProgress(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
