class Conversation {
  Conversation({
    required this.id,
    required this.createdAt,
    required this.product,
    required this.sender,
    required this.receiver,
    required this.isRead,
    this.recent_message_sender,
    this.recent_message,
    this.recent_message_time,
  });
  late final int id;
  late final String createdAt;
  late final ConvProd product;
  late final ChatUser sender;
  late final ChatUser receiver;
  late bool isRead;
  late final ChatUser? recent_message_sender;
  late final String? recent_message;
  late final String? recent_message_time;

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    product = ConvProd.fromJson(json['product']);
    sender = ChatUser.fromJson(json['sender']);
    receiver = ChatUser.fromJson(json['receiver']);
    isRead = json['is_read'];
    recent_message_sender = json['recent_message_sender'] != null
        ? ChatUser.fromJson(json['recent_message_sender'])
        : null;
    recent_message = json['recent_message'];
    recent_message_time = json['recent_message_time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created_at'] = createdAt;
    _data['product'] = product.toJson();
    _data['sender'] = sender.toJson();
    _data['receiver'] = receiver.toJson();
    _data['is_read'] = isRead;
    if (recent_message_sender != null) {
      _data['recent_message_sender'] = recent_message_sender!.toJson();
    }
    _data['recent_message'] = recent_message;
    _data['recent_message_time'] = recent_message_time;

    return _data;
  }
}

class ConvProd {
  ConvProd({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
  late final int id;
  late final String title;
  late final String image;
  late final String price;

  ConvProd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['image'] = image;
    _data['price'] = price;
    return _data;
  }
}

class ChatUser {
  ChatUser({
    required this.id,
    required this.firstName,
    required this.image,
    required this.dateJoined,
  });
  late final int id;
  late final String firstName;
  late final String image;
  late final String dateJoined;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    image = json['image'];
    dateJoined = json['date_joined'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['image'] = image;
    _data['date_joined'] = dateJoined;
    return _data;
  }
}
