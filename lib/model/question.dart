class Question {
  final int questionNum;
  final String question;
  final List<String> answerOptions;
  final String answer;
  String? selectedOption;

  Question({
    this.questionNum = 0,
    this.question = "",
    this.answerOptions = const [],
    this.answer = "",
    this.selectedOption,
  });

  static final dummy = Question(
    questionNum: 1,
    question: "question",
    answerOptions: ["answer1", "answer2", "answer3"],
    answer: "answer3",
  );

  static final dummy2 = Question(
    questionNum: 2,
    question: "question2",
    answerOptions: ["answer1", "answer2", "answer3"],
    answer: "answer1",
  );

  static final dummy3 = Question(
    questionNum: 3,
    question: "question3",
    answerOptions: ["answer1", "answer2", "answer3"],
    answer: "answer2",
  );

  bool get isAnswered => selectedOption != null;

  bool get isCorrectlyAnswered => selectedOption == answer;

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      questionNum: data['questionNum'] ?? 0,
      question: data['question'] ?? '',
      answerOptions: List<String>.from(data['answerOptions'] ?? []),
      answer: data['answer'] ?? '',
      selectedOption: data['selectedOption'],
    );
  }
}
