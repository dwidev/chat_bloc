import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/matchloves/matchloves.dart';

class ReplyChatWidget extends StatefulWidget {
  const ReplyChatWidget({
    super.key,
  });
  @override
  State<ReplyChatWidget> createState() => _ReplyChatWidgetState();
}

class _ReplyChatWidgetState extends State<ReplyChatWidget>
    with TickerProviderStateMixin {
  late TextEditingController controller;

  late final _tween =
      Tween(begin: const Offset(0, 70), end: const Offset(0, 0));
  late final AnimationController animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = _tween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void closeReplyChat() {
    animationController.reverse(from: 0).whenComplete(() {
      context.read<ChatBloc>().add(const ReplyChat(null));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.replayChat != current.replayChat,
      listener: (context, state) {
        if (state.replayChat != null) {
          animationController.forward();
        } else {
          closeReplyChat();
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Visibility(
              visible: _animation.value.dy < 70,
              child: Transform.translate(
                offset: _animation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  color: Colors.grey.shade100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.reply,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${state.replayChat?.senderID}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${state.replayChat?.content}",
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          closeReplyChat();
                        },
                        child: Transform.scale(
                          origin: const Offset(0, -15),
                          scale: 0.5,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            child: const Icon(
                              CupertinoIcons.clear,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
