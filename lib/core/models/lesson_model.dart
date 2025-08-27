class Lesson {
  final String id;
  // This new field will help us identify the module.
  final String moduleId;
  final String title;
  final String syllabusArea;
  final String content;
  final List<String> keyPoints;

  const Lesson({
    required this.id,
    // Add to constructor
    required this.moduleId,
    required this.title,
    required this.syllabusArea,
    required this.content,
    required this.keyPoints,
  });

  // I'm adding a factory constructor to create a Lesson from a JSON map.
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      // Add to fromJson factory
      moduleId: json['moduleId'],
      title: json['title'],
      syllabusArea: json['syllabusArea'],
      content: json['content'],
      keyPoints: List<String>.from(json['keyPoints']),
    );
  }
}
