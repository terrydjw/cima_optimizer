import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserProgress({
    required String userId,
    required String moduleId,
    required Set<String> answeredQuestionIds,
    required Set<String> correctlyAnsweredQuestionIds,
    required Map<String, int> topicAttempts,
    required Map<String, int> topicCorrectAnswers,
    required Map<String, int> subTopicAttempts,
    required Map<String, int> subTopicCorrectAnswers,
    required List<Map<String, dynamic>> recentQuizzes,
  }) async {
    try {
      final userProgressDocRef = _db
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(moduleId);
      await userProgressDocRef.set({
        'answeredQuestionIds': answeredQuestionIds.toList(),
        'correctlyAnsweredQuestionIds': correctlyAnsweredQuestionIds.toList(),
        'topicAttempts': topicAttempts,
        'topicCorrectAnswers': topicCorrectAnswers,
        'subTopicAttempts': subTopicAttempts,
        'subTopicCorrectAnswers': subTopicCorrectAnswers,
        'recentQuizzes': recentQuizzes,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserProgress({
    required String userId,
    required String moduleId,
  }) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(moduleId)
          .get();
      return doc.data();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
