// lib/blocs/Chat/chat_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/models/chat_message_model.dart';
import 'package:tataguid/repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<ChatMessage>? _messageSubscription;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<LoadMessages>(_onLoadMessages);
  }

  Future<void> _onConnectWebSocket(ConnectWebSocket event, Emitter<ChatState> emit) async {
    try {
      chatRepository.connect(event.userId);

      _messageSubscription?.cancel();
      _messageSubscription = chatRepository.messageStream.listen((message) {
        add(ReceiveMessage(message.senderId, message.msgText));
      });

      emit(ChatConnected());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      if (!chatRepository.connected) {
        emit(ChatError("WebSocket is not connected."));
        return;
      }
      await chatRepository.sendMessage(event.receiverId, event.msgText);
      emit(ChatMessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) async {
    emit(ChatMessageReceived(ChatMessage(
      senderId: event.senderId,
      msgText: event.msgText,
      timestamp: DateTime.now().toString(),
    )));
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getMessages(event.userId, event.receiverId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    chatRepository.dispose();
    return super.close();
  }
}
