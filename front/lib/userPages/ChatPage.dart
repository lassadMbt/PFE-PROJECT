import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/Chat/chat_bloc.dart';
import 'package:tataguid/blocs/Chat/chat_event.dart';
import 'package:tataguid/blocs/Chat/chat_state.dart';
import 'package:tataguid/repository/chat_repository.dart';

class ChatPage extends StatelessWidget {
  final String userId;
  final String receiverId;
  final String agencyName;

  const ChatPage({
    Key? key,
    required this.userId,
    required this.receiverId,
    this.agencyName = 'Unknown Agency',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepository();
    final textController = TextEditingController();

    return BlocProvider(
      create: (context) => ChatBloc(chatRepository: chatRepository)
        ..add(ConnectWebSocket(userId))
        ..add(LoadMessages(userId, receiverId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$agencyName'),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChatConnected || state is ChatLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$agencyName'),
                  ),
                  Expanded(
                    child: state is ChatLoaded
                        ? ListView.builder(
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return ListTile(
                                title: Text(message.msgText),
                                subtitle: Text(
                                  message.senderId == userId ? 'You' : agencyName,
                                ),
                              );
                            },
                          )
                        : Center(child: Text('No messages loaded.')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            final text = textController.text;
                            if (text.isNotEmpty) {
                              BlocProvider.of<ChatBloc>(context).add(
                                SendMessage(receiverId, text),
                              );
                              textController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is ChatError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Failed to load messages'));
            }
          },
        ),
      ),
    );
  }
}
