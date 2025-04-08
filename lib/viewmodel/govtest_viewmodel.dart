import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:govtest_general/model/test.dart';
import 'package:govtest_general/model/test_repository.dart';
import 'package:govtest_general/model/topic.dart';

class GovtestViewmodel extends ChangeNotifier {
  int? _program;
  List<Topic>? _topics;
  String _service = "lawenf";
  Test test = Test(questions: List.empty(), topic: '1');

  int? get program => _program;

  List<Topic>? get topics => _topics;

  String get service => _service;

  int _index = 0;

  int get index => _index;

  bool get isFirstQuestion => index == 0;
  bool get isLastQuestion => index == test.questions.length - 1;

  bool programAvailability1 = false;
  bool programAvailability2 = false;
  bool programAvailability3 = false;

  set index(int val) {
    _index = val;
    notifyListeners();
  }

  void nextQuestion(Function finish) {
    if (index < test.questions.length - 1) {
      index++;
      notifyListeners();
    } else if (isLastQuestion) {
      finish();
    }
  }

  void prevQuestion() {
    if (index > 0) {
      index--;
    }
  }

  void answerQuestion(int questionIndex, int answerIndex) {
    test[questionIndex].selectedOption =
        test[questionIndex].answerOptions[answerIndex];
    notifyListeners();
  }

  set service(String val) {
    _service = val;
    notifyListeners();
  }

  void setServiceSilent(String val) {
    _service = val;
    _topics = null;
  }

  void setProgramSilent(int val) {
    isLoading = true;
    program = val;
    programChosen = true;
  }

  final TestRepository repository;

  GovtestViewmodel({required this.repository});

  final auth = FirebaseAuth.instance;

  bool isLoading = true;

  bool programChosen = false;

  // set topics(List<String>? newTopics) {
  //   topics = newTopics;
  //   notifyListeners();
  // }

  set program(int? newProgram) {
    program = newProgram;
    notifyListeners();
  }

  void updateTopics() async {
    isLoading = true;
    var result = await repository.getTopics(service);
    log(result.error.toString());

    if (result.isSuccess) {
      var topics = result.data;

      var userId = auth.currentUser?.uid;
      log("UserID:$userId");
      log("Service:$service");

      programAvailability1 =
          (await repository.checkProgram(service, 1, userId!)).data!;
      programAvailability2 =
          (await repository.checkProgram(service, 2, userId)).data!;
      programAvailability3 =
          (await repository.checkProgram(service, 3, userId)).data!;

      if (topics != null) {
        for (Topic topic in topics) {
          var isAvailable = checkTopic(
            service,
            topic.topicId,
            programAvailability1,
            programAvailability2,
            programAvailability3,
          );
          topic.isAvailable = isAvailable;
        }
      }

      log(
        "topics: ${topics?.map((topic) => topic.isAvailable.toString()).toList().toString()}",
      );

      _topics = topics;
      isLoading = false;
      notifyListeners();
    }
  }

  void updateTest() async {
    var result = await repository.getQuestions(service, int.parse(test.topic));
    if (result.isFailure) {
      log("ERROR:${result.error}");
      return;
    }

    test.questions = result.data!;
    isLoading = false;
    notifyListeners();
  }

  void updateTestProgram() async {
    isLoading = true;
    try {
      test.questions = List.empty();

      for (int topicId in servToProgramToTopicIds[service][program]) {
        int topicSize = (await repository.getTopicSize(service, topicId)).data!;
        final randomIndexes = List<int>.generate(topicSize, (i) => i + 1)
          ..shuffle();
        final selectedIndexes = randomIndexes.take(15).toList();

        test.questions.addAll(
          (await repository.getQuestionsWithIndexes(
            service,
            topicId,
            selectedIndexes,
          )).data!,
        );
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log("ERROR:$e");
      return;
    }
  }

  Map<dynamic, dynamic> servToProgramToTopicIds = {
    "admin": {
      1: {0, 1, 2, 3, 4, 6, 7, 8, 9},
      2: {0, 1, 3, 5, 6, 7, 8, 9},
      3: {0, 3, 5, 6, 7, 8, 9},
    },
    "lawenf": {
      1: {0, 1, 2, 3, 4, 6, 7, 8, 9},
      2: {0, 1, 3, 5, 6, 7, 8, 9},
      3: {0, 3, 5, 6, 7, 8, 9},
    },
  };

  bool checkTopic(
    String branch,
    int topicId,
    bool program1,
    bool program2,
    bool program3,
  ) {
    bool program1Check = servToProgramToTopicIds[branch][1].contains(topicId);
    bool program2Check = servToProgramToTopicIds[branch][2].contains(topicId);
    bool program3Check = servToProgramToTopicIds[branch][3].contains(topicId);
    log("$topicId $program1 ${servToProgramToTopicIds[branch][1].contains(0)}");
    return (program1 && program1Check) ||
        (program2 && program2Check) ||
        (program3 && program3Check);
  }
}
