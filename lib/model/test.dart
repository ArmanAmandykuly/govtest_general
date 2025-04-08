import 'package:govtest_general/model/question.dart';

class Test {
  String topic;
  List<Question> questions;

  Test({
    required this.topic,
    required this.questions,
  });

  Question operator [](int index) => questions[index];

  int get size => questions.length;

  static final dummy = Test(
    topic: "kek",
    questions: [Question.dummy, Question.dummy2, Question.dummy3],
  );
}