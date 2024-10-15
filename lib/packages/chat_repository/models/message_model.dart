// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_x/packages/chat_repository/entities/message_entity.dart';

import '../../user_repository/models/user_model.dart';

class Message {
  String chatId;
  MyUser sender;
  MyUser receiver;
  String message;
  DateTime createdAt;

  Message({
    required this.chatId,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.createdAt,
  });
  
  static var empty = Message(chatId: '', sender: MyUser.empty, receiver: MyUser.empty, message: '', createdAt: DateTime.now());

  MessageEntity toEntity() {
    return MessageEntity(
        chatId: chatId,
        sender: sender,
        receiver: receiver,
        message: message,
        createdAt: createdAt);
  }

  static Message fromEntity(MessageEntity entity) {
    return Message(
        chatId: entity.chatId,
        sender: entity.sender,
        receiver: entity.receiver,
        message: entity.message,
        createdAt: entity.createdAt);
  }
}
