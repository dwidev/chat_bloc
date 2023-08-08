// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ws_connection_bloc.dart';

@immutable
class WsConnectionState extends Equatable {
  final WSConnectionStatus connecionStatus;
  final int reconnectionAttemps;

  const WsConnectionState(
    this.connecionStatus,
    this.reconnectionAttemps,
  );

  @override
  List<Object> get props => [connecionStatus, reconnectionAttemps];

  WsConnectionState copyWith({
    WSConnectionStatus? connecionStatus,
    int? reconnectionAttemps,
  }) {
    return WsConnectionState(
      connecionStatus ?? this.connecionStatus,
      reconnectionAttemps ?? this.reconnectionAttemps,
    );
  }

  @override
  bool get stringify => true;
}

class WsConnectionInitial extends WsConnectionState {
  const WsConnectionInitial() : super(WSConnectionStatus.connecting, 0);
}
