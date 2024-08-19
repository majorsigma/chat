
class Chat {
  String? chatId;
  String? receipientId;
  List<String>? members;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;
  List<Message>? messages;

  Chat({
    this.chatId,
    this.members,
    this.receipientId,
    this.lastMessage,
    this.lastMessageTime,
    this.createdAt,
    this.messages,
  });

  factory Chat.fromMap(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'] as String?,
      receipientId: json["receipientId"] as String?,
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
      createdAt: json['createdAt'] as String?,
      messages: json['messages'] != null
          ? List<Message>.from(json['messages'].map((x) => Message.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'receipientId': receipientId,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'messages': messages?.map((x) => x.toMap()).toList(),
    };
  }
}

class Message {
  String? messageId;
  String? senderId;
  String? receiverId;
  String? message;
  String? createdAt;
  Message({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.message,
    this.createdAt,
  });

  Message copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? message,
    String? createdAt,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'createdAt': createdAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Message(messageId: $messageId, senderId: $senderId, receiverId: $receiverId, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.messageId == messageId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.message == message &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        message.hashCode ^
        createdAt.hashCode;
  }
}
