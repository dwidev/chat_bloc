import 'package:chat_bloc/chat/cubit/react_animation_cubit.dart';

import '../bloc/conversations_bloc/conversations_bloc.dart';
import '../bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../data/datasources/ws_datasource.dart';
import '../data/model/conversation_model.dart';
import '../data/repository/chat_repository.dart';
import 'chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc/chat_bloc.dart';

class ConversationsPage extends StatefulWidget {
  final String me;
  const ConversationsPage({
    Key? key,
    required this.me,
  }) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    context.read<WsConnectionBloc>().add(ConnectToWs(token: widget.me));
    context.read<ConversationsBloc>()
      ..add(GetConversations(widget.me))
      ..add(const ConversationSubscribeMessage())
      ..add(const ConversationSubscribeUserTyping());
    super.initState();
  }

  void _detailChat(String sender, ConversationModel conversation) {
    final repo = context.read<ChatRepository>();
    final convBloc = context.read<ConversationsBloc>();

    convBloc.add(ConversationReadMessage(conversation));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryProvider.value(
          value: repo,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: convBloc),
              BlocProvider(create: (context) => ReactAnimationCubit()),
              BlocProvider(
                create: (context) => ChatBloc(
                  chatRepository: context.read<ChatRepository>(),
                ),
              ),
            ],
            child: ChatPage(
              conversationModel: conversation,
              me: widget.me,
              receiver: conversation.user,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Conversations")),
      body: Column(
        children: [
          BlocBuilder<WsConnectionBloc, WsConnectionState>(
            builder: (context, state) {
              if (state.connecionStatus == WSConnectionStatus.disconnected) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.amber.shade200),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "failed to connect to server, try connecting again...",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.connecionStatus ==
                  WSConnectionStatus.disconnectedWithReconnectAttempts) {
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Reconnecting failed with $attemptsReconnecting attempts, try again",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<WsConnectionBloc>()
                                .add(ConnectToWs(token: widget.me));
                            context
                                .read<ConversationsBloc>()
                                .add(GetConversations(widget.me));
                          },
                          child: const Text("reconnect"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.connecionStatus == WSConnectionStatus.connecting) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.green.shade200),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Connecting to server... "),
                  ),
                );
              }

              return const Offstage();
            },
          ),
          BlocConsumer<ConversationsBloc, ConversationsState>(
            listener: (context, state) {
              // if (state is ChatErrorConnectWS) {
              //   final snackBar = SnackBar(
              //     content: Text(state.error.toString()),
              //   );

              //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // }
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = state.conversations[index];
                    final sender = conversation.user;

                    return InkWell(
                      onTap: () {
                        _detailChat(sender.id, conversation);
                      },
                      child: ListTile(
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              conversation.lastMessage?.dateConv ?? '',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            if (conversation.unreadCount > 0) ...[
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "${conversation.unreadCount}",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ],
                        ),
                        leading: Stack(
                          children: [
                            const CircleAvatar(),
                            if (conversation.user.online)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(sender.name),
                        subtitle: conversation.user.typing
                            ? Text(
                                "mengetik...",
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.purpleAccent.shade100,
                                ),
                              )
                            : Text(
                                conversation.lastMessage?.content ??
                                    "Belum ada percakapan",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: conversation.unread(widget.me)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
