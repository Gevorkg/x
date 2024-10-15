import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_repository/entities/user_entity.dart';
import '../../user_repository/models/user_model.dart';

class MessageEntity {
  String chatId;
  MyUser sender;
  MyUser receiver;
  String message;
  DateTime createdAt;

  MessageEntity({
    required this.chatId,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.createdAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'chatId': chatId,
      'sender': sender.toEntity().toDocument(),
      'receiver': receiver.toEntity().toDocument(),
      'message': message,
      'createdAt': createdAt
    };
  }

  static MessageEntity fromDocument(Map<String, dynamic> doc) {
    return MessageEntity(
      chatId: doc['chatId'] as String,
      sender: MyUser.fromEntity(MyUserEntity.fromDocument(doc['sender'])),
      receiver: MyUser.fromEntity(MyUserEntity.fromDocument(doc['receiver'])),
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      message: doc['message'] as String,
    );
  }
}