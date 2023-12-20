import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/conversations_bloc/conversations_bloc.dart';
import '../bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../data/repository/chat_repository.dart';
import 'converstaions_page.dart';

class LoginDummyPage extends StatefulWidget {
  const LoginDummyPage({super.key});

  @override
  State<LoginDummyPage> createState() => _LoginDummyPageState();
}

class _LoginDummyPageState extends State<LoginDummyPage> {
  String me = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              // controller: TextEditingController(text: me),
              decoration: const InputDecoration(hintText: "username"),
              onChanged: (value) {
                setState(() {
                  me = value;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiBlocProvider(
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
                    },
                  ),
                );
              },
              child: const Text("Masuk"),
            )
          ],
        ),
      ),
    );
  }
}
