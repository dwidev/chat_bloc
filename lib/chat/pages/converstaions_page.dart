import 'package:chat_bloc/chat/cubit/react_animation_cubit.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

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
  static Widget build(String me) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WsConnectionBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ConversationsBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
        ],
        child: ConversationsPage(me: me),
      );

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
    print("INIT STATE CHAT PAGE");
    context.read<WsConnectionBloc>().add(ConnectToWs(token: widget.me));
    context.read<ConversationsBloc>()
      ..add(GetConversations(widget.me))
      ..add(const ConversationSubscribeMessage())
      ..add(const ConversationSubscribeUserTyping());
    super.initState();
  }

  @override
  void dispose() {
    print("DISPONSE CONVERSATIONS");
    super.dispose();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkLightColor,
      appBar: AppBar(
        title: Text(
          "Messages",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.exclamationmark_shield_fill,
              color: blueLightColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<WsConnectionBloc, WsConnectionState>(
                builder: (context, state) {
                  if (state.connecionStatus ==
                      WSConnectionStatus.disconnected) {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "New Matches",
                  style: textTheme.bodySmall,
                ),
              ),
              Container(
                // padding: EdgeInsets.all(20),
                width: size.width,
                height: 70,
                // color: darkColor,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyUsers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          right: 10, left: index == 0 ? 10 : 0.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(dummyUsers[index]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Messages",
                  style: textTheme.bodySmall,
                ),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
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
                                    color: greenColor,
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
                              CircleAvatar(
                                backgroundImage: NetworkImage(dummyUsers[1]),
                              ),
                              if (conversation.user.online)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: greenColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: whiteColor),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            sender.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: conversation.user.typing
                              ? Text(
                                  "mengetik...",
                                  style: textTheme.labelSmall?.copyWith(
                                    color: primaryColor,
                                  ),
                                )
                              : Text(
                                  conversation.lastMessage?.content ??
                                      "Belum ada percakapan",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.black),
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
