import 'models/message_model.dart';

abstract class ChatRepository {
  Future<Message> sendMessage(Message message);

  Stream<List<Message>> getMessages(String userId1, String userId2);
}
