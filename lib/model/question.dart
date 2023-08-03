class Question {
  int questionId;
  String userId;
  String title;
  String description;
  String question;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.questionId,
    required this.userId,
    required this.title,
    required this.description,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}
