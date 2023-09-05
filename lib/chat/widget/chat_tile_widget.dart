import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/react_animation_cubit.dart';
import '../data/model/chat_message_model.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.isMe,
    required this.onReplyChat,
    required this.startAnimation,
  });

  final ChatMessageModel chat;
  final bool isMe;
  final VoidCallback? onReplyChat;

  final bool startAnimation;

  factory ChatTile.overlay({
    required ChatMessageModel chat,
    required bool isMe,
  }) {
    return ChatTile(
      chat: chat,
      isMe: isMe,
      onReplyChat: null,
      startAnimation: false,
    );
  }

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> with TickerProviderStateMixin {
  final _key = GlobalKey();
  late ReactAnimationCubit reactAnimate;

  /// SWIPE ANIMATION
  final Tween<Offset> _tween = Tween<Offset>();
  late final AnimationController _swipeAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<Offset> _animation = _tween.animate(
      CurvedAnimation(parent: _swipeAnimationController, curve: Curves.ease));
  late final Animation<double> _animationOpacity = Tween(begin: 1.0, end: 0.0)
      .animate(CurvedAnimation(
          parent: _swipeAnimationController, curve: Curves.ease));

  Offset offset = Offset.zero;
  double leftIconOpacity = 0.0;

  bool isReact = false;

  @override
  void initState() {
    reactAnimate = context.read<ReactAnimationCubit>();
    // reactAnimate.initAnimationForEmoticon(vsync: this, isSender: widget.isMe);
    _swipeAnimationController.addListener(onListenSwipeController);

    super.initState();
  }

  void onListenSwipeController() {
    onHorizontalDragUpdate(
      offset: _animation.value,
      opacityHide: _animationOpacity.value,
    );
  }

  @override
  void dispose() {
    _swipeAnimationController.removeListener(onListenSwipeController);
    _swipeAnimationController.dispose();

    super.dispose();
  }

  void onHorizontalDragUpdate({required Offset offset, double? opacityHide}) {
    final valueOpacity = double.parse(((offset / 100).dx).toStringAsFixed(1));
    final leftIconOpacityShow = leftIconOpacity + valueOpacity;
    final leftIconOpacityHide = leftIconOpacity - valueOpacity;

    setState(() {
      if (offset.dx > 40 &&
          this.offset.dx < offset.dx &&
          leftIconOpacityShow <= 1 &&
          leftIconOpacity <= 0.9) {
        leftIconOpacity = leftIconOpacityShow;
      }

      if (opacityHide == null &&
          this.offset.dx > offset.dx &&
          leftIconOpacity >= 0.1) {
        leftIconOpacity -= leftIconOpacityHide;
      }

      if (opacityHide != null) {
        leftIconOpacity = opacityHide;
      }

      this.offset = offset;
    });
  }

  void reset() {
    _tween.begin = offset;
    _tween.end = Offset.zero;
    _swipeAnimationController.reset();
    _swipeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      key: _key,
      onLongPress: () {
        final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
        Offset offset = renderBox.localToGlobal(Offset.zero);
        reactAnimate.showChatReactOverlay(
          vsync: this,
          offset: offset,
          selectedChat: widget.chat,
          isSender: widget.isMe,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Positioned(
            left: 15,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: double.parse(leftIconOpacity.toStringAsFixed(1)),
              child: Transform.scale(
                scale: 0.8,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    CupertinoIcons.reply,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (widget.onReplyChat == null) {
                return;
              }

              if (offset.dx <= 0 && details.delta.dx <= 0) {
                return;
              }

              onHorizontalDragUpdate(offset: offset + details.delta * 0.3);
            },
            onHorizontalDragEnd: (details) {
              if (offset.dx <= 0) {
                return;
              }

              reset();
              widget.onReplyChat?.call();
            },
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Transform.translate(
                    offset: offset,
                    child: Column(
                      crossAxisAlignment: widget.isMe
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: size.width / 1.2,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: widget.isMe
                                  ? Colors.deepPurple.shade100
                                  : Colors.pinkAccent.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.chat.content,
                                    overflow: TextOverflow.clip,
                                    style: textTheme.bodyLarge,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.chat.date,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.startAnimation) ...[
                          Visibility(
                            visible: widget.chat.emoticons.isNotEmpty,
                            child: AnimatedBuilder(
                              animation:
                                  reactAnimate.emoticonAnimationController,
                              builder: (context, c) {
                                return Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedContainer(
                                            alignment: Alignment.centerLeft,
                                            duration: const Duration(
                                              milliseconds: 150,
                                            ),
                                            width: 25,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                          ),
                                          // shadow react
                                          Container(
                                            width: reactAnimate
                                                    .emoticonshadowAnimation
                                                    .value +
                                                2,
                                            height: reactAnimate
                                                .emoticonshadowAnimation.value,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade600
                                                  .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          )
                                        ],
                                      ),
                                      if (widget.chat.emoticons.contains(
                                          reactAnimate.state.selectedEmoticon))
                                        Transform.rotate(
                                          // angle: reactAnimate
                                          //     .emoticonRotateAnimation.value,
                                          angle: 0,
                                          child: Transform.translate(
                                            offset: reactAnimate
                                                .emoticonOffsetAnimation.value,
                                            child: Transform.scale(
                                              scale: reactAnimate
                                                  .emoticonScaleAnimation.value,
                                              child: Text(reactAnimate
                                                  .state.selectedEmoticon),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          if (widget.chat.emoticons.isNotEmpty)
                            Transform.translate(
                              offset: const Offset(0, -5),
                              child: AnimatedContainer(
                                alignment: Alignment.centerLeft,
                                duration: const Duration(
                                  milliseconds: 150,
                                ),
                                width: 25,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: Transform.translate(
                                  offset: Offset(2, -2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: widget.chat.emoticons
                                        .map((e) => Transform.scale(
                                            scale: 1, child: Text(e)))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                        ]
                      ],
                    ),
                  ),
                ),
                //   )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
