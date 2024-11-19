// lib/models/chat_message_model.dart

class ChatMessage {
  final String senderId;
  final String msgText;
  final String timestamp;

  ChatMessage({
    required this.senderId,
    required this.msgText,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      msgText: json['msgtext'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'msgtext': msgText,
      'timestamp': timestamp,
    };
  }
}
