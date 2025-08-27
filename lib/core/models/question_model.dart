class Question {
  final String id;
  final String moduleId;
  // This new field provides more granular tracking.
  final String syllabusSubArea;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.id,
    required this.moduleId,
    // Add to constructor
    required this.syllabusSubArea,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      moduleId: json['moduleId'],
      // Add to fromJson factory
      syllabusSubArea: json['syllabusSubArea'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}
