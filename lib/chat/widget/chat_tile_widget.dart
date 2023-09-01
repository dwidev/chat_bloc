import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/model/chat_message_model.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.isMe,
    required this.onReplyChat,
    required this.onLongPress,
    required this.dummyReaction,
    required this.emot,
  });

  factory ChatTile.overlay({
    required ChatMessageModel chat,
    required bool isMe,
  }) {
    return ChatTile(
      chat: chat,
      isMe: isMe,
      onReplyChat: null,
      onLongPress: null,
      dummyReaction: '',
      emot: '',
    );
  }

  final ChatMessageModel chat;
  final bool isMe;
  final VoidCallback? onReplyChat;
  final Function(Offset offset, ChatMessageModel msg)? onLongPress;
  final String dummyReaction, emot;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> with TickerProviderStateMixin {
  final _key = GlobalKey();

  final Tween<Offset> _tween = Tween<Offset>();
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150));

  late final AnimationController _controllerReact = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  late final Animation<Offset> _animationReact =
      Tween(begin: const Offset(0, -50), end: const Offset(0, 0)).animate(
          CurvedAnimation(parent: _controllerReact, curve: Curves.bounceOut));

  late final Animation<Offset> _animation =
      _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

  late final Animation<double> _animationOpacity = Tween(begin: 1.0, end: 0.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

  Offset offset = Offset.zero;
  double leftIconOpacity = 0.0;

  bool isReact = false;

  @override
  void initState() {
    _controller.addListener(() {
      onHorizontalDragUpdate(
        offset: _animation.value,
        opacityHide: _animationOpacity.value,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _controllerReact.dispose();
    _controller.dispose();
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
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final size = MediaQuery.of(context).size;
    if (widget.emot.isNotEmpty && widget.dummyReaction == widget.chat.content) {
      _controllerReact.forward();
    } else {
      _controllerReact.reset();
    }

    return GestureDetector(
      key: _key,
      onLongPress: () {
        if (widget.onLongPress != null) {
          final renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          Offset offset = renderBox.localToGlobal(Offset.zero);
          widget.onLongPress?.call(offset, widget.chat);
          setState(() {
            isReact = true;
          });
        }
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
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: widget.isMe
                                ? Colors.deepPurple.shade100
                                : Colors.grey.shade200,
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
                      ],
                    ),
                  ),
                ),
                if (widget.emot.isNotEmpty &&
                    widget.dummyReaction == widget.chat.content)
                  Positioned(
                    left: !widget.isMe ? null : 10,
                    right: !widget.isMe ? 10 : null,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: _animationReact,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: _animationReact.value,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              widget.emot,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 9),
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
