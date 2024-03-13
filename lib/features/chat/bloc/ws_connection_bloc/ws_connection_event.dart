part of 'ws_connection_bloc.dart';

sealed class WsConnectionEvent {
  const WsConnectionEvent();
}

final class ConnectToWs extends WsConnectionEvent {
  final String token;

  const ConnectToWs({required this.token});
}

final class ListenReconnectionWS extends WsConnectionEvent {
  final String token;

  const ListenReconnectionWS({required this.token});
}
