import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/message_bloc/message_bloc.dart';
import '../../../packages/chat_repository/models/message_model.dart';
import '../../../packages/user_repository/models/user_model.dart';
import '../../components/TextField.dart';

class ChatScreen extends StatefulWidget {
  final MyUser sender;
  final MyUser receiver;

  const ChatScreen({
    required this.sender,
    required this.receiver,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Message message;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    message = Message(
      chatId: '',
      sender: widget.sender,
      receiver: widget.receiver,
      message: '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is CreateMessageSuccess) {
          _messageController.clear();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            }
          });
        } else if (state is MessagesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        } else if (state is MessageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load/send message: ${state.error}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessagesLoaded) {
                    final messages = state.messages;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final msg = messages[i];
                        final isMe = msg.sender.id == widget.sender.id;
                        final bool showAvatarAndName = i == 0 ||
                            messages[i - 1].sender.id != msg.sender.id;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (showAvatarAndName)
                                Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (!isMe)
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            NetworkImage(msg.sender.picture!),
                                      ),
                                    const SizedBox(width: 8),
                                    if (isMe)
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            NetworkImage(msg.sender.picture!),
                                      ),
                                  ],
                                ),
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.blue[200]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(msg.message),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No messages'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _messageController,
                      hintText: 'Type your message...',
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        message.message = _messageController.text;
                        context.read<MessageBloc>().add(CreateMessage(message));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message cannot be empty'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.send), 
                     
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
