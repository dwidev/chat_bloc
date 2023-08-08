part of 'conversations_bloc.dart';

@immutable
class ConversationsState extends Equatable {
  final UserRoomInfo userRoomInfo;
  final List<ConversationModel> conversations;

  const ConversationsState({
    required this.userRoomInfo,
    required this.conversations,
  });

  const ConversationsState.initial({
    this.conversations = const [],
    this.userRoomInfo = const UserRoomInfo(),
  });

  @override
  List<Object> get props => [conversations, userRoomInfo];

  ConversationsState copyWith({
    UserRoomInfo? userRoomInfo,
    List<ConversationModel>? conversations,
  }) {
    return ConversationsState(
      userRoomInfo: userRoomInfo ?? this.userRoomInfo,
      conversations: conversations ?? this.conversations,
    );
  }

  @override
  bool get stringify => true;
}

@immutable
class UserRoomInfo extends Equatable {
  final bool standByAtroom;
  final String roomBy;

  const UserRoomInfo({this.standByAtroom = false, this.roomBy = ''});

  @override
  List<Object?> get props => [standByAtroom, roomBy];

  @override
  bool get stringify => true;
}
