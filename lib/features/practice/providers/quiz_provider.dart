import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/question_model.dart';
import '../../../core/models/lesson_model.dart';
import '../../../core/services/lesson_service.dart';
import '../../../core/services/ai_tutor_service.dart';
import '../../auth/services/database_service.dart';
import '../../auth/services/auth_service.dart';
import '../quiz_results_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResult {
  final String topic;
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  QuizResult({
    required this.topic,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      topic: map['topic'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

enum QuizStatus { notStarted, inProgress, finished }

class QuizProvider extends ChangeNotifier {
  final LessonService _lessonService = LessonService();
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService;
  final AITutorService _aiTutorService;

  User? _user;

  List<Question> _fullQuestionList = [];
  List<Question> _sessionQuestions = [];
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  QuizStatus _status = QuizStatus.notStarted;

  int _sessionScore = 0;
  String _sessionTopic = 'Full Syllabus';
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _answerChecked = false;

  final Set<String> _answeredQuestionIds = {};
  final Map<String, int> _topicCorrectAnswers = {};
  final Map<String, int> _topicAttempts = {};
  final List<QuizResult> _recentQuizzes = [];

  bool _isExplanationLoading = false;
  String? _explanationText;

  // Getters
  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;
  QuizStatus get status => _status;
  int get currentQuestionIndex => _currentQuestionIndex;
  Question get currentQuestion => _sessionQuestions[_currentQuestionIndex];
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get answerChecked => _answerChecked;
  int get sessionScore => _sessionScore;
  int get totalQuestions => _sessionQuestions.length;
  List<QuizResult> get recentQuizzes => _recentQuizzes;
  int get totalAnsweredQuestions => _answeredQuestionIds.length;
  bool get isExplanationLoading => _isExplanationLoading;
  String? get explanationText => _explanationText;

  double get syllabusCoverage {
    if (_fullQuestionList.isEmpty) return 0.0;
    return _answeredQuestionIds.length / _fullQuestionList.length;
  }

  double getPerformanceForArea(String area) {
    final totalAreaQuestions = _fullQuestionList
        .where((q) => q.id.startsWith(area))
        .length;
    if (totalAreaQuestions == 0) return 0.0;
    final correct = _topicCorrectAnswers[area] ?? 0;
    return correct / totalAreaQuestions;
  }

  Lesson? get weakestTopic {
    if (_topicAttempts.isEmpty) return null;
    String? weakestArea;
    double lowestScore = 1.1;
    _topicAttempts.forEach((area, attempts) {
      final correct = _topicCorrectAnswers[area] ?? 0;
      final score = correct / attempts;
      if (score < lowestScore) {
        lowestScore = score;
        weakestArea = area;
      }
    });
    if (weakestArea == null) return null;
    return _lessons.firstWhere(
      (lesson) => lesson.syllabusArea == weakestArea,
      orElse: () => _lessons.first,
    );
  }

  QuizProvider(this._authService, this._aiTutorService) {
    _init();
  }

  Future<void> _init() async {
    _fullQuestionList = await _lessonService.getQuestions();
    _lessons = await _lessonService.getLessons();
    _sessionQuestions = _fullQuestionList;
    _user = _authService.currentUser;
    if (_user != null) {
      await _loadProgress();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadProgress() async {
    final progress = await _dbService.getUserProgress(_user!.uid);
    if (progress != null) {
      _answeredQuestionIds.clear();
      _answeredQuestionIds.addAll(
        Set<String>.from(progress['answeredQuestionIds'] ?? []),
      );
      _topicCorrectAnswers.clear();
      _topicCorrectAnswers.addAll(
        Map<String, int>.from(progress['topicCorrectAnswers'] ?? {}),
      );
      _topicAttempts.clear();
      _topicAttempts.addAll(
        Map<String, int>.from(progress['topicAttempts'] ?? {}),
      );
      _recentQuizzes.clear();
      final loadedQuizzes = List<Map<String, dynamic>>.from(
        progress['recentQuizzes'] ?? [],
      );
      _recentQuizzes.addAll(
        loadedQuizzes.map((map) => QuizResult.fromMap(map)),
      );
    }
  }

  Future<void> _saveProgress() async {
    if (_user == null) return;
    await _dbService.updateUserProgress(
      userId: _user!.uid,
      answeredQuestionIds: _answeredQuestionIds,
      topicAttempts: _topicAttempts,
      topicCorrectAnswers: _topicCorrectAnswers,
      recentQuizzes: _recentQuizzes.map((quiz) => quiz.toMap()).toList(),
    );
  }

  List<Question> getQuestionsForArea(String? area) {
    if (area == null) {
      return _fullQuestionList;
    }
    return _fullQuestionList.where((q) => q.id.startsWith(area)).toList();
  }

  void startQuiz(List<Question> questions, String topic) {
    if (questions.isEmpty) return;
    questions.shuffle();
    _sessionQuestions = questions;
    _sessionTopic = topic;
    _sessionScore = 0;
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _answerChecked = false;
    _status = QuizStatus.inProgress;
    _explanationText = null;
    notifyListeners();
  }

  void checkAnswer() {
    if (_selectedAnswerIndex == null) return;
    final question = currentQuestion;
    final area = question.id.substring(0, 1);
    _topicAttempts.update(area, (value) => value + 1, ifAbsent: () => 1);
    _answeredQuestionIds.add(question.id);
    if (_selectedAnswerIndex == question.correctAnswerIndex) {
      _sessionScore++;
      _topicCorrectAnswers.update(
        area,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    _answerChecked = true;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_status != QuizStatus.inProgress || _answerChecked) return;
    _selectedAnswerIndex = index;
    notifyListeners();
  }

  void finishQuiz() {
    _status = QuizStatus.finished;
    _recentQuizzes.insert(
      0,
      QuizResult(
        topic: _sessionTopic,
        score: _sessionScore,
        totalQuestions: _sessionQuestions.length,
        timestamp: DateTime.now(),
      ),
    );
    if (_recentQuizzes.length > 3) {
      _recentQuizzes.removeLast();
    }
    _saveProgress();
    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    if (_currentQuestionIndex < _sessionQuestions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _answerChecked = false;
      _explanationText = null;
      notifyListeners();
    } else {
      finishQuiz();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuizResultsScreen()),
      );
    }
  }

  void cancelQuiz() {
    _status = QuizStatus.notStarted;
    _sessionQuestions = _fullQuestionList;
    _explanationText = null;
    notifyListeners();
  }

  Future<void> getExplanation() async {
    _isExplanationLoading = true;
    _explanationText = null;
    notifyListeners();
    final question = currentQuestion;
    final correctAnswer = question.options[question.correctAnswerIndex];
    final explanation = await _aiTutorService.getExplanation(
      question: question.questionText,
      correctAnswer: correctAnswer,
      allOptions: question.options,
    );
    _explanationText = explanation;
    _isExplanationLoading = false;
    notifyListeners();
  }
}
