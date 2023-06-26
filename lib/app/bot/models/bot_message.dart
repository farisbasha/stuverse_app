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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['timestamp'] = timestamp;
    _data['is_bot'] = isBot;
    _data['content'] = content;
    _data['conversation'] = conversation;
    return _data;
  }
}
