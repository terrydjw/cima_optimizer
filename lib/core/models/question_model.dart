class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  // I'm adding a factory constructor to create a Question from a JSON map.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}
