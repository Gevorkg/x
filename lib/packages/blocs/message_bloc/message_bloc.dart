import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/chat_repository/chat_repo.dart';
import '../../chat_repository/models/message_model.dart';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  ChatRepository chatRepository;
  MessageBloc({required this.chatRepository}) : super(MessageInitial()) {
    on<CreateMessage>((event, emit) async {
      emit(MessageSending());
      try {
        final Message message = await chatRepository.sendMessage(event.message);

        emit(CreateMessageSuccess(message));

        add(LoadMessages(event.message.sender.id, event.message.receiver.id));
      } catch (e) {
        emit(CreateMessageFailure(e.toString()));
      }
    });

    on<LoadMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        await emit.forEach<List<Message>>(
          chatRepository.getMessages(event.userId1, event.userId2),
          onData: (messages) => MessagesLoaded(messages),
          onError: (error, _) => MessageFailure(error.toString()),
        );
      } catch (e) {
        emit(MessageFailure(e.toString()));
      }
    });
    
    
  }
     
  }

