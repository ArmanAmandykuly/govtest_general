import 'package:govtest_general/data/gov_service.dart';
import 'package:govtest_general/model/test.dart';
import 'package:govtest_general/model/topic.dart';

class GovTestUiState {
  final int topicId;
  final GovService govService;
  final Test test;
  final List<Topic>? topics;
  final int index;
  final bool testPassed;
  final String token;
  final bool isAuthenticated;
  final List<bool> testsAvailability;

  GovTestUiState._({
    required this.topicId,
    required this.govService,
    required this.test,
    required this.topics,
    required this.index,
    required this.testPassed,
    required this.token,
    required this.isAuthenticated,
    required this.testsAvailability,
  });

  factory GovTestUiState({
    int topicId = 0,
    GovService? govService,
    Test? test,
    List<Topic>? topics,
    int index = 0,
    bool testPassed = false,
    String token = "",
    bool isAuthenticated = false,
    List<bool>? testsAvailability,
  }) {
    return GovTestUiState._(
      topicId: topicId,
      govService: govService ?? GovService.adminService,
      test: test ?? Test.dummy,
      topics: topics ?? [Topic(topicId: 1, topic: "k2k", isAvailable: true)],
      index: index,
      testPassed: testPassed,
      token: token,
      isAuthenticated: isAuthenticated,
      testsAvailability: testsAvailability ?? [false, false, false],
    );
  }

  GovTestUiState copyWith({
    int? topicId,
    GovService? govService,
    Test? test,
    List<Topic>? topics,
    int? index,
    bool? testPassed,
    String? token,
    bool? isAuthenticated,
    List<bool>? testsAvailability,
  }) {
    return GovTestUiState(
      topicId: topicId ?? this.topicId,
      govService: govService ?? this.govService,
      test: test ?? this.test,
      topics: topics ?? this.topics,
      index: index ?? this.index,
      testPassed: testPassed ?? this.testPassed,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      testsAvailability: testsAvailability ?? this.testsAvailability,
    );
  }
}
