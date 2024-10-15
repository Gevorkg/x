part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class CreateMessage extends MessageEvent{ 
  final Message message;

  CreateMessage(this.message);
}

class LoadMessages extends MessageEvent {
  final String userId1;
  final String userId2;

  LoadMessages(this.userId1, this.userId2);

  @override
  List<Object> get props => [userId1, userId2];
}

