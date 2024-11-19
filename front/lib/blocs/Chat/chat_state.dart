// lib/blocs/Chat/chat_state.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/chat_message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnected extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatMessageSent extends ChatState {}

class ChatMessageReceived extends ChatState {
  final ChatMessage message;

  const ChatMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}
