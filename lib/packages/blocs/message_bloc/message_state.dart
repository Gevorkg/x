part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

class MessageSending extends MessageState {}

class CreateMessageSuccess extends MessageState {
  final Message message;

  CreateMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CreateMessageFailure extends MessageState{ 
  final String error;

  CreateMessageFailure(this.error);
}

class MessageLoading extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<Message> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageFailure extends MessageState {
  final String error;

  MessageFailure(this.error);

  @override
  List<Object> get props => [error];
}

