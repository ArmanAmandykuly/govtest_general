import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govtest_general/model/question.dart';
import 'dart:async';

import 'package:govtest_general/model/test_repository.dart';
import 'package:govtest_general/model/topic.dart';

class TestRepositoryImpl implements TestRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Topic>> getTopic(String branch, int topicId) async {
    try {
      DocumentSnapshot document =
          await firestore.collection(branch).doc("$topicId").get();
      if (document.exists) {
        Topic topic = Topic(
          topicId: topicId,
          topic: document["topic"],
          isAvailable: false,
        );
        return Result.success(topic);
      } else {
        return Result.failure(Exception("Topic not found"));
      }
    } catch (e) {
      return Result.failure(Exception(e));
    }
  }

  @override
  Future<Result<List<Topic>>> getTopics(String branch) async {
    try {
      QuerySnapshot snapshot = await firestore.collection(branch).get();
      return Result.success(
        snapshot.docs.where((doc) => int.tryParse(doc.id) != null).map((doc) {
          return Topic(
            topicId: int.tryParse(doc.id) ?? -1,
            topic: doc.get("topic") ?? "Unknown Topic",
            isAvailable: false,
          );
        }).toList(),
      );
    } catch (e) {
      return Result.failure(Exception(e));
    }
  }

  @override
  Future<Result<List<Question>>> getQuestions(
    String branch,
    int topicId,
  ) async {
    try {
      QuerySnapshot snapshot =
          await firestore
              .collection(branch)
              .doc("$topicId")
              .collection("questions")
              .get();
      List<Question> questions =
          snapshot.docs.map((doc) {
            log(doc.data().toString());
            return Question.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return Result.success(questions);
    } catch (e) {
      return Result.failure(Exception(e));
    }
  }

  @override
  Future<Result<List<Question>>> getQuestionsWithIndexes(
    String branch,
    int topicId,
    List<int> indexes,
  ) async {
    try {
      List<Future<DocumentSnapshot>> tasks =
          indexes.map((index) {
            return firestore
                .collection(branch)
                .doc("$topicId")
                .collection("questions")
                .doc(index.toString())
                .get();
          }).toList();

      List<DocumentSnapshot> docs = await Future.wait(tasks);
      List<Question> questions =
          docs.map((doc) {
            return Question.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

      return Result.success(questions);
    } catch (e) {
      return Result.failure(Exception("Couldn't fetch questions"));
    }
  }

  @override
  Future<Result<int>> getTopicSize(String branch, int topicId) async {
    try {
      DocumentSnapshot docRef =
          await firestore.collection(branch).doc("$topicId").get();
      int size = (docRef["size"] ?? 0) as int;
      return Result.success(size);
    } catch (e) {
      return Result.failure(Exception("Couldn't fetch topic sizes"));
    }
  }

  @override
  Future<Result<bool>> checkProgram(
    String branch,
    int program,
    String userId,
  ) async {
    try {
      DocumentSnapshot docRef =
          await firestore
              .collection(branch)
              .doc("programUsers")
              .collection("$program")
              .doc(userId)
              .get();
      return Result.success(docRef.exists);
    } catch (e) {
      return Result.failure(Exception("Error checking program"));
    }
  }
}
