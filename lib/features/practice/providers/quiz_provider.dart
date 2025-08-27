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
  String? _currentModuleId;

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

  final Map<String, int> _subTopicCorrectAnswers = {};
  final Map<String, int> _subTopicAttempts = {};

  bool _isExplanationLoading = false;
  String? _explanationText;

  // State for in-quiz tools
  String _notepadText = '';
  String _calculatorExpression = '';
  String _calculatorResult = '0';

  // --- Getters ---
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
  String get notepadText => _notepadText;
  String get calculatorExpression => _calculatorExpression;
  String get calculatorResult => _calculatorResult;

  double get syllabusCoverage {
    if (_fullQuestionList.isEmpty) return 0.0;
    return _answeredQuestionIds.length / _fullQuestionList.length;
  }

  double getPerformanceForArea(String area) {
    final totalAreaQuestions = _fullQuestionList
        .where((q) => q.syllabusSubArea.startsWith(area))
        .length;
    if (totalAreaQuestions == 0) return 0.0;
    final correct = _topicCorrectAnswers[area] ?? 0;
    return correct / totalAreaQuestions;
  }

  Lesson? get weakestTopic {
    if (_subTopicAttempts.isEmpty) return null;
    String? weakestSubAreaId;
    double lowestScore = 1.1;
    _subTopicAttempts.forEach((subArea, attempts) {
      if (attempts > 0) {
        final correct = _subTopicCorrectAnswers[subArea] ?? 0;
        final score = correct / attempts;
        if (score < lowestScore) {
          lowestScore = score;
          weakestSubAreaId = subArea;
        }
      }
    });
    if (weakestSubAreaId == null) return null;
    try {
      return _lessons.firstWhere((lesson) => lesson.id == weakestSubAreaId);
    } catch (e) {
      return _lessons.isNotEmpty ? _lessons.first : null;
    }
  }

  Map<String, double> get subTopicPerformance {
    final Map<String, double> performanceMap = {};
    _subTopicAttempts.forEach((subArea, attempts) {
      if (attempts > 0) {
        final correct = _subTopicCorrectAnswers[subArea] ?? 0;
        performanceMap[subArea] = correct / attempts;
      }
    });
    final sortedEntries = performanceMap.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return Map.fromEntries(sortedEntries);
  }

  QuizProvider(this._authService, this._aiTutorService) {
    _init();
  }

  void _init() {
    _user = _authService.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDataForModule(String moduleId) async {
    _isLoading = true;
    notifyListeners();
    _currentModuleId = moduleId;

    clearModuleData(); // Use the clear method to reset everything

    _fullQuestionList = await _lessonService.getQuestions(moduleId: moduleId);
    _lessons = await _lessonService.getLessons(moduleId: moduleId);

    if (_user != null) {
      await _loadProgress(moduleId: moduleId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadProgress({required String moduleId}) async {
    final progress = await _dbService.getUserProgress(
      userId: _user!.uid,
      moduleId: moduleId,
    );
    if (progress != null) {
      _answeredQuestionIds.addAll(
        Set<String>.from(progress['answeredQuestionIds'] ?? []),
      );
      _topicCorrectAnswers.addAll(
        Map<String, int>.from(progress['topicCorrectAnswers'] ?? {}),
      );
      _topicAttempts.addAll(
        Map<String, int>.from(progress['topicAttempts'] ?? {}),
      );
      _subTopicCorrectAnswers.addAll(
        Map<String, int>.from(progress['subTopicCorrectAnswers'] ?? {}),
      );
      _subTopicAttempts.addAll(
        Map<String, int>.from(progress['subTopicAttempts'] ?? {}),
      );
      final loadedQuizzes = List<Map<String, dynamic>>.from(
        progress['recentQuizzes'] ?? [],
      );
      _recentQuizzes.addAll(
        loadedQuizzes.map((map) => QuizResult.fromMap(map)),
      );
    }
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    if (_user == null || _currentModuleId == null) return;
    await _dbService.updateUserProgress(
      userId: _user!.uid,
      moduleId: _currentModuleId!,
      answeredQuestionIds: _answeredQuestionIds,
      topicAttempts: _topicAttempts,
      topicCorrectAnswers: _topicCorrectAnswers,
      subTopicAttempts: _subTopicAttempts,
      subTopicCorrectAnswers: _subTopicCorrectAnswers,
      recentQuizzes: _recentQuizzes.map((quiz) => quiz.toMap()).toList(),
    );
  }

  List<Question> getQuestionsForArea(String? area) {
    if (area == null) {
      return _fullQuestionList;
    }
    return _fullQuestionList
        .where((q) => q.syllabusSubArea.startsWith(area))
        .toList();
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
    _notepadText = '';
    _calculatorExpression = '';
    _calculatorResult = '0';
    notifyListeners();
  }

  void checkAnswer() {
    if (_selectedAnswerIndex == null) return;
    final question = currentQuestion;
    final area = question.syllabusSubArea.substring(0, 1);
    _topicAttempts.update(area, (value) => value + 1, ifAbsent: () => 1);
    final subArea = question.syllabusSubArea;
    _subTopicAttempts.update(subArea, (value) => value + 1, ifAbsent: () => 1);
    _answeredQuestionIds.add(question.id);
    if (_selectedAnswerIndex == question.correctAnswerIndex) {
      _sessionScore++;
      _topicCorrectAnswers.update(
        area,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      _subTopicCorrectAnswers.update(
        subArea,
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
      _notepadText = '';
      _calculatorExpression = '';
      _calculatorResult = '0';
      notifyListeners();
    } else {
      finishQuiz();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuizResultsScreen()),
      );
    }
  }

  void cancelQuiz() {
    _status = QuizStatus.notStarted;
    _sessionQuestions = [];
    _explanationText = null;
    _notepadText = '';
    _calculatorExpression = '';
    _calculatorResult = '0';
    notifyListeners();
  }

  Future<void> getExplanation() async {
    _isExplanationLoading = true;
    _explanationText = null;
    notifyListeners();
    final question = currentQuestion;
    final correctAnswer = question.options[question.correctAnswerIndex];
    if (_currentModuleId == null) {
      _explanationText = 'Error: No module selected.';
      _isExplanationLoading = false;
      notifyListeners();
      return;
    }
    final explanation = await _aiTutorService.getExplanation(
      question: question.questionText,
      correctAnswer: correctAnswer,
      allOptions: question.options,
      moduleId: _currentModuleId!,
    );
    _explanationText = explanation;
    _isExplanationLoading = false;
    notifyListeners();
  }

  void clearModuleData() {
    _currentModuleId = null;
    _fullQuestionList.clear();
    _lessons.clear();
    _answeredQuestionIds.clear();
    _topicCorrectAnswers.clear();
    _topicAttempts.clear();
    _subTopicCorrectAnswers.clear();
    _subTopicAttempts.clear();
    _recentQuizzes.clear();
    _status = QuizStatus.notStarted;
    notifyListeners();
  }

  void updateNotepadText(String text) {
    _notepadText = text;
  }

  void updateCalculatorState(String expression, String result) {
    _calculatorExpression = expression;
    _calculatorResult = result;
    notifyListeners();
  }
}
