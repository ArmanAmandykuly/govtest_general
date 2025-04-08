class Topic {
  final int topicId;
  String topic;
  bool isAvailable;

  Topic({this.topicId = 0, this.topic = "", this.isAvailable = false});

  static final List<Topic> topics = [
    Topic(topicId: 1, topic: "topic1", isAvailable: true),
    Topic(topicId: 2, topic: "topic2", isAvailable: false),
    Topic(topicId: 3, topic: "topic3", isAvailable: true),
  ];

  factory Topic.fromMap(Map<String, dynamic> data, String documentId) {
    return Topic(
      topicId: int.tryParse(documentId) ?? 0, // Using documentId as topicId
      topic: data['topic'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
    );
  }
}
