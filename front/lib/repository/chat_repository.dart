// lib/repository/chat_repository.dart

import 'dart:async';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tataguid/models/chat_message_model.dart';
import 'package:web_socket_channel/io.dart';


class ChatRepository {
  IOWebSocketChannel? _channel;
  bool connected = false;
  final _messageController = StreamController<ChatMessage>.broadcast();
  Timer? _reconnectTimer;

  Stream<ChatMessage> get messageStream => _messageController.stream;

void connect(String token) {
  if (connected) return; // Prevent multiple connections

  try {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    String userId = payload['id']; // Extract user ID from token payload

    var uri = Uri.parse("ws://192.168.1.10:6060/$userId");
    print("Connecting to WebSocket with userId: $userId");

    _channel = IOWebSocketChannel.connect(uri);
    _channel!.stream.listen(
      (message) {
        var data = json.decode(message);
        print("Received data: $data");

        if (data['cmd'] == 'connected' && data['status'] == 'success') {
          connected = true;
          print("Connection established.");
          _reconnectTimer?.cancel();
        } else if (data['cmd'] == 'send' && data['status'] == 'success') {
          print("Message sent successfully");
        } else if (data['cmd'] == 'send' && data['status'] == 'error') {
          print("Message send error: ${data['error'] ?? 'Unknown error'}");
        } else if (data['cmd'] == 'message') {
          _messageController.add(ChatMessage.fromJson(data));
        }
      },
      onDone: () {
        print("WebSocket connection closed");
        connected = false;
        _reconnect();
      },
      onError: (error) {
        print("WebSocket connection error: $error");
        connected = false;
        _reconnect();
      },
    );
  } catch (e) {
    print("WebSocket connection exception: $e");
    connected = false;
    _reconnect();
  }
}

  void _reconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive)
      return; // Prevent multiple timers
    print("Attempting to reconnect...");
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (!connected) {
        connect("reconnect");
      } else {
        _reconnectTimer?.cancel();
      }
    });
  }
Future<void> sendMessage(String receiverId, String msgText) async {
  if (_channel != null && connected) {
    print("Sending message to receiverId: $receiverId...");
    _channel!.sink.add(json.encode({
      'cmd': 'send',
      'auth': 'addauthkeyifrequired', // Add this if required
      'msgtext': msgText,
      'receiverId': receiverId,
    }));
  } else {
    print("WebSocket is not connected.");
    throw Exception("WebSocket is not connected.");
  }
}


  Future<List<ChatMessage>> getMessages(
      String userId, String receiverId) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return [
      ChatMessage(
        senderId: receiverId,
        msgText: "Hello!",
        timestamp: DateTime.now().toString(),
      ),
      ChatMessage(
        senderId: userId,
        msgText: "Hi there!",
        timestamp: DateTime.now().toString(),
      ),
    ]; // Simulated messages
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}
