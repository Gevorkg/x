import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_x/packages/chat_repository/chat_repo.dart';
import 'entities/message_entity.dart';
import 'models/message_model.dart';

class FirebaseChatRepository implements ChatRepository {
  final CollectionReference _messageCollection =
      FirebaseFirestore.instance.collection('messages');

  final _usersCollection = FirebaseFirestore.instance.collection('users');

  String generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1-$userId2' : '$userId2-$userId1';
}

 @override
Future<Message> sendMessage(Message message) async {
  try {
    final String chatId =
        generateChatId(message.sender.id, message.receiver.id);
    message.chatId = chatId;
    message.createdAt = DateTime.now();

    final chatDoc = _messageCollection.doc(chatId);

    await chatDoc
        .collection('chatMessages')
        .add(message.toEntity().toDocument());

    final senderSnapshot = await _usersCollection.doc(message.sender.id).get();
    final List<dynamic> senderChatGuests = senderSnapshot['chatguests'] ?? [];

    if (!senderChatGuests.any((guest) => guest['id'] == message.receiver.id)) {
      await _usersCollection.doc(message.sender.id).update({
        'chatguests': FieldValue.arrayUnion([message.receiver.toEntity().toDocument()])
      });
    }

    final receiverSnapshot = await _usersCollection.doc(message.receiver.id).get();
    final List<dynamic> receiverChatGuests = receiverSnapshot['chatguests'] ?? [];

    if (!receiverChatGuests.any((guest) => guest['id'] == message.sender.id)) {
      await _usersCollection.doc(message.receiver.id).update({
        'chatguests': FieldValue.arrayUnion([message.sender.toEntity().toDocument()])
      });
    }

    return message;
  } catch (e) {
    rethrow;
  }
}

  @override
  Stream<List<Message>> getMessages(String userId1, String userId2) {
    final String chatId = generateChatId(userId1, userId2);
    return _messageCollection
        .doc(chatId)
        .collection('chatMessages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromEntity(MessageEntity.fromDocument(doc.data()));
      }).toList();
    });
  }
}
