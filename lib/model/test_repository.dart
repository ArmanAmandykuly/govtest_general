import 'dart:async';

import 'package:govtest_general/model/question.dart';
import 'package:govtest_general/model/topic.dart';

abstract class TestRepository {
  Future<Result<Topic>> getTopic(String branch, int topicId);
  Future<Result<List<Topic>>> getTopics(String branch);
  Future<Result<List<Question>>> getQuestions(String branch, int topicId);
  Future<Result<List<Question>>> getQuestionsWithIndexes(String branch, int topicId, List<int> indexes);
  Future<Result<int>> getTopicSize(String branch, int topicId);
  Future<Result<bool>> checkProgram(String branch, int program, String userId);
}

class Result<T> {
  final T? data;
  final Exception? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}