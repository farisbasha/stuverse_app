class BotMessage {
  BotMessage({
    required this.id,
    required this.timestamp,
    required this.isBot,
    required this.content,
    required this.conversation,
  });
  late final int id;
  late final String timestamp;
  late final bool isBot;
  late final String content;
  late final int conversation;

  BotMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    isBot = json['is_bot'];
    content = json['content'];
    conversation = json['conversation'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['timestamp'] = timestamp;
    data['is_bot'] = isBot;
    data['content'] = content;
    data['conversation'] = conversation;
    return data;
  }
}
