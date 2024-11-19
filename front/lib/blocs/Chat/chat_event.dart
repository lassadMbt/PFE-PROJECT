// lib/blocs/Chat/chat_event.dart

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends ChatEvent {
  final String userId;

  const ConnectWebSocket(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String msgText;

  const SendMessage(this.receiverId, this.msgText);

  @override
  List<Object> get props => [receiverId, msgText];
}

class ReceiveMessage extends ChatEvent {
  final String senderId;
  final String msgText;

  const ReceiveMessage(this.senderId, this.msgText);

  @override
  List<Object> get props => [senderId, msgText];
}

class LoadMessages extends ChatEvent {
  final String userId;
  final String receiverId;

  const LoadMessages(this.userId, this.receiverId);

  @override
  List<Object> get props => [userId, receiverId];
}
