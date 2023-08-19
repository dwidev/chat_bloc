import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/conversations_bloc/conversations_bloc.dart';
import '../data/model/user_model.dart';

class ChatLastSeenAnimationWidget extends StatefulWidget {
  const ChatLastSeenAnimationWidget({
    super.key,
    required this.conversationID,
  });

  final String conversationID;

  @override
  State<ChatLastSeenAnimationWidget> createState() =>
      _ChatLastSeenAnimationWidgetState();
}

class _ChatLastSeenAnimationWidgetState
    extends State<ChatLastSeenAnimationWidget>
    with SingleTickerProviderStateMixin {
  bool showLastWacth = false;
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          setState(() {
            showLastWacth = true;
          });
        }
      });

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));
    Future.delayed(const Duration(seconds: 1), () {
      animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("REBUILD ChatLastSeenAnimationWidget");
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<ConversationsBloc, ConversationsState>(
      listener: (context, state) {
        if (state is ConversationsOfflineUserState) {
          animationController.reset();
          setState(() {
            showLastWacth = false;
          });
          Future.delayed(const Duration(seconds: 2), () {
            animationController
              ..stop()
              ..forward();
          });
        }
      },
      child: BlocSelector<ConversationsBloc, ConversationsState, UserModel?>(
        selector: (state) => state.conversations
            .where((element) => element.conversationID == widget.conversationID)
            .firstOrNull
            ?.user,
        builder: (context, state) {
          print("BUILD BlocSelector<ConversationsBloc");
          final user = state;
          final isOnline = user?.online ?? false;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: ScaleTransition(
                  scale: animation,
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
              );
            },
            child: isOnline
                ? Text(
                    key: ValueKey<bool>(isOnline),
                    user?.status ?? "",
                    style: textTheme.bodySmall,
                  )
                : SlideTransition(
                    position: offsetAnimation,
                    child: Text(
                      key: ValueKey<bool>(isOnline),
                      showLastWacth
                          ? user?.lastWatch ?? ''
                          : user?.lastSeen ?? '',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
