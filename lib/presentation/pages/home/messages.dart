import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';

import '../../../packages/blocs/message_bloc/message_bloc.dart';
import '../../../packages/chat_repository/firebase_chat_repos.dart';
import '../../components/TextStyle.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.success) {
          final currentUser = state.user!;
          return Scaffold(
              backgroundColor: Colors.white,
              body: ListView.builder(
                  itemCount: currentUser.chatguests.length,
                  itemBuilder: (context, int i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => MessageBloc(
                                    chatRepository: FirebaseChatRepository(),
                                  )..add(
                                      LoadMessages(currentUser.id,
                                          currentUser.chatguests[i].id),
                                    ),
                                ),
                              ],
                              child: ChatScreen(
                                sender: currentUser,
                                receiver: currentUser.chatguests[i],
                              ),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: currentUser.chatguests[i].picture !=
                                      null &&
                                  currentUser.chatguests[i].picture!.isNotEmpty
                              ? NetworkImage(currentUser.chatguests[i].picture!)
                              : null,
                          child: currentUser.chatguests[i].picture == null ||
                                  currentUser.chatguests[i].picture!.isEmpty
                              ? Text(currentUser.chatguests[i].name[0]
                                  .toUpperCase())
                              : null,
                        ),
                        title:
                            MyTxtStlName(text: currentUser.chatguests[i].name),
                        subtitle: MyTxtStlTime(
                            text: '@${currentUser.chatguests[i].nickname}'),
                      ),
                    );
                  }));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
