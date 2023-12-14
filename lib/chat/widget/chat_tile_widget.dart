import 'package:chat_bloc/chat/bloc/chat_bloc/chat_bloc.dart';
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
  });

  final ChatMessageModel chat;
  final bool isMe;
  final VoidCallback? onReplyChat;

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

  final emoticonAnimationDuration = const Duration(milliseconds: 1000);
  late final AnimationController emoticonAnimationController;
  late CurvedAnimation curvedEmoticonAnimation;

  late TweenSequence<Offset> tweenOffsetEmoticon;
  late Animation<Offset> emoticonOffsetAnimation;

  late Tween<double> tweenShadowEmoticon;
  late Animation<double> emoticonshadowAnimation;

  late Tween<double> tweenOpacityEmoticon;
  late Animation<double> emoticonOpcityAnimation;

  late TweenSequence<double> tweenScaleEmoticon;
  late Animation<double> emoticonScaleAnimation;

  late AnimationController emoticonBackgroundController;
  late Tween<double> tweenEmotBgWidth;
  late Animation<double> emotBgWidthAnimation;
  late Tween<double> tweenEmotBgHeight;
  late Animation<double> emotBgHeightAnimation;

  Offset offset = Offset.zero;
  double leftIconOpacity = 0.0;

  bool isReact = false;

  @override
  void initState() {
    // emot.addAll(widget.chat.emoticons);
    reactAnimate = context.read<ReactAnimationCubit>();
    // initAnimationForEmoticon(vsync: this, isSender: widget.isMe);
    _swipeAnimationController.addListener(onListenSwipeController);

    initAnimationForBackgroundEmoticon(vsync: this);
    initAnimationForEmoticon(vsync: this);

    final readyMyEmot = widget.chat.myEmoticon.isNotEmpty;
    if (readyMyEmot) {
      reactAnimate.initEmoticonValues(
        selectedChat: widget.chat,
        emoticonAnimationController: emoticonAnimationController,
        emoticonBackgroundController: emoticonBackgroundController,
        selectedEmoticon: widget.chat.myEmoticon,
        tweenEmotBgWidth: tweenEmotBgWidth,
      );
    }

    super.initState();
  }

  void initAnimationForBackgroundEmoticon({
    required TickerProvider vsync,
  }) {
    final readyEmot = widget.chat.emoticons.isNotEmpty;
    final isTwoEmot = widget.chat.emoticons.length == 2;

    emoticonBackgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    final curved = CurvedAnimation(
      parent: emoticonBackgroundController,
      curve: Curves.easeIn,
    );

    tweenEmotBgWidth = Tween(begin: 10, end: isTwoEmot ? 25 * 2 : 25);
    emotBgWidthAnimation = tweenEmotBgWidth.animate(curved);
    tweenEmotBgHeight = Tween(begin: 20, end: 20);
    emotBgHeightAnimation = tweenEmotBgHeight.animate(curved);

    if (readyEmot) {
      emoticonBackgroundController.value = 1.0;
    }
  }

  void initAnimationForEmoticon({
    required TickerProvider vsync,
  }) {
    final readyEmot = widget.chat.emoticons.isNotEmpty;

    emoticonAnimationController = AnimationController(
      vsync: vsync,
      duration: emoticonAnimationDuration,
    );

    curvedEmoticonAnimation = CurvedAnimation(
      parent: emoticonAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    // set offset animation
    tweenOffsetEmoticon = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, -30),
          end: const Offset(0, 0),
        ).chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
        weight: 0.5,
      ),
    ]);
    emoticonOffsetAnimation = tweenOffsetEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set shadow of emoticon
    tweenShadowEmoticon = Tween<double>(begin: 10, end: 0.0);
    emoticonshadowAnimation = tweenShadowEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set opacity emoticon
    tweenOpacityEmoticon = Tween(begin: 0.2, end: 1.0);
    emoticonOpcityAnimation = tweenOpacityEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set scale emoticon
    tweenScaleEmoticon = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 2.5, end: 0.8),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 2.0)
            .chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 2.5, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceInOut)),
        weight: 1,
      ),
    ]);

    emoticonScaleAnimation = tweenScaleEmoticon.animate(
      curvedEmoticonAnimation,
    );

    if (readyEmot) {
      emoticonAnimationController.value = 1.0;
    }
  }

  void onListenSwipeController() {
    onHorizontalDragUpdate(
      offset: _animation.value,
      opacityHide: _animationOpacity.value,
    );
  }

  @override
  void dispose() {
    reactAnimate.state.disponseAnimationController(widget.chat.messageId);
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
    final senderEmot = widget.chat.senderEmoticon.isEmpty;

    // final textTheme = Theme.of(context).textTheme;
    // final size = MediaQuery.of(context).size;

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatReceiveEmot) {
          final chat = state.chatsReceiveEmot
              .where((e) => e.messageId == widget.chat.messageId)
              .firstOrNull;
          if (chat != null) {
            final isTwoEmot = chat.emoticons.length > 1;
            final curved = CurvedAnimation(
              parent: emoticonBackgroundController,
              curve: Curves.easeIn,
            );
            tweenEmotBgWidth.begin = tweenEmotBgWidth.end;
            tweenEmotBgWidth.end = isTwoEmot ? 25 * 2 : 25;
            tweenEmotBgWidth.animate(curved);
            emoticonBackgroundController
              ..reset()
              ..forward();

            // tweenEmotBgWidth = Tween(begin: 10, end: isTwoEmot ? 25 * 2 : 25);
            // emotBgWidthAnimation = tweenEmotBgWidth.animate(curved);
            // tweenEmotBgHeight = Tween(begin: 20, end: 20);
            // emotBgHeightAnimation = tweenEmotBgHeight.animate(curved);
          }
        }
      },
      child: GestureDetector(
        key: _key,
        onLongPress: () {
          final renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          Offset offset = renderBox.localToGlobal(Offset.zero);

          reactAnimate.initEmoticonValues(
            selectedChat: widget.chat,
            emoticonAnimationController: emoticonAnimationController,
            emoticonBackgroundController: emoticonBackgroundController,
            tweenEmotBgWidth: tweenEmotBgWidth,
            selectedEmoticon: '',
          );

          reactAnimate.showChatReactOverlay(
            offset: offset,
            selectedChat: widget.chat,
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
              child: Container(
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Transform.translate(
                  offset: offset,
                  child: Column(
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      ChatBubleWidget(chat: widget.chat, isMe: widget.isMe),
                      BlocBuilder<ReactAnimationCubit, ReactAnimationState>(
                        builder: (context, state) {
                          final myEmoticon = state.getEmoticon(
                            widget.chat.messageId,
                          );

                          // print("KESINI EMG YA : $state");
                          if (widget.chat.emoticons.isNotEmpty ||
                              myEmoticon.isNotEmpty) {
                            return AnimatedBuilder(
                              animation: Listenable.merge([
                                emoticonAnimationController,
                                emoticonBackgroundController
                              ]),
                              builder: (context, _) {
                                return Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Container of background emot
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        width: emotBgWidthAnimation.value,
                                        height: emotBgHeightAnimation.value,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      // Container of shadow emot animation
                                      Positioned(
                                        right: !senderEmot ? 10 : null,
                                        child: Container(
                                          width:
                                              emoticonshadowAnimation.value + 2,
                                          height: emoticonshadowAnimation.value,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade600
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      // Emoticon for animation
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(widget.chat.senderEmoticon),
                                          Transform.translate(
                                            offset:
                                                emoticonOffsetAnimation.value,
                                            child: Transform.scale(
                                              scale:
                                                  emoticonScaleAnimation.value,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                ),
                                                child: Text(myEmoticon),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          return const Offstage();
                        },
                      )
                      // AnimatedSwitcher(
                      //   duration: const Duration(milliseconds: 300),
                      //   child: widget.startAnimation
                      //       ? Visibility(
                      //           visible: widget.chat.emoticons.isNotEmpty,
                      //           child: AnimatedBuilder(
                      //             animation:
                      //                 emoticonAnimationController,
                      //             builder: (context, _) {
                      //               return Transform.translate(
                      //                 offset: const Offset(0, -5),
                      //                 child: Stack(
                      //                   alignment: Alignment.center,
                      //                   children: [
                      //                     AnimatedContainer(
                      //                       padding: const EdgeInsets.symmetric(
                      //                         horizontal: 5,
                      //                         vertical: 2,
                      //                       ),
                      //                       duration: const Duration(
                      //                         milliseconds: 1500,
                      //                       ),
                      //                       decoration: BoxDecoration(
                      //                         color: Colors.grey.shade300,
                      //                         borderRadius:
                      //                             BorderRadius.circular(50),
                      //                         border: Border.all(
                      //                           color: Colors.white,
                      //                           width: 1,
                      //                         ),
                      //                       ),
                      //                       child: Transform.translate(
                      //                         offset: reactAnimate
                      //                             .emoticonOffsetAnimation.value,
                      //                         child: Transform.scale(
                      //                           scale: reactAnimate
                      //                               .emoticonScaleAnimation.value,
                      //                           child: Container(
                      //                             padding:
                      //                                 const EdgeInsets.symmetric(
                      //                               horizontal: 2,
                      //                             ),
                      //                             child: Text(reactAnimate
                      //                                 .state.selectedEmoticon),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     // shadow react
                      //                     Container(
                      //                       width: reactAnimate
                      //                               .emoticonshadowAnimation
                      //                               .value +
                      //                           2,
                      //                       height: reactAnimate
                      //                           .emoticonshadowAnimation.value,
                      //                       decoration: BoxDecoration(
                      //                         color: Colors.grey.shade600
                      //                             .withOpacity(0.4),
                      //                         borderRadius:
                      //                             BorderRadius.circular(10),
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         )
                      //       : widget.chat.emoticons.isNotEmpty
                      //           ? Transform.translate(
                      //               offset: const Offset(0, -5),
                      //               child: AnimatedContainer(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   horizontal: 5,
                      //                   vertical: 2,
                      //                 ),
                      //                 duration: const Duration(
                      //                   milliseconds: 1500,
                      //                 ),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.grey.shade300,
                      //                   borderRadius: BorderRadius.circular(50),
                      //                   border: Border.all(
                      //                     color: Colors.white,
                      //                     width: 1,
                      //                   ),
                      //                 ),
                      //                 child: Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: widget.chat.emoticons
                      //                       .map(
                      //                         (e) => Container(
                      //                           padding:
                      //                               const EdgeInsets.symmetric(
                      //                             horizontal: 2,
                      //                           ),
                      //                           child: Text(e),
                      //                         ),
                      //                       )
                      //                       .toList(),
                      //                 ),
                      //               ),
                      //             )
                      //           : const Offstage(),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubleWidget extends StatelessWidget {
  const ChatBubleWidget({
    super.key,
    required this.chat,
    required this.isMe,
  });

  final ChatMessageModel chat;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width / 1.2,
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: !isMe ? Colors.grey.shade100 : Colors.pinkAccent.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                chat.content,
                overflow: TextOverflow.clip,
                style: textTheme.bodyLarge?.copyWith(
                  color: !isMe ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              chat.date,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
